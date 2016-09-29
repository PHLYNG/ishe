class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects
  has_many :project_comments, dependent: :destroy

  accepts_nested_attributes_for :users

  has_attached_file :photo,
  styles: { medium: "200x200>", thumb: "100x100>" },
  :url => "/system/:class/:attachment/:id_partition/:style/:filename",
  :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"

  has_attached_file :verify_photo,
  :url => "/system/projects/:class/:attachment/:id_partition/:style/:filename",
  :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"

  validates :project_type, presence: true

  # Validate filename
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :verify_photo, attachment_presence: true, on: :update
  validates_attachment_file_name :verify_photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :verify_photo, :less_than => 10.megabytes
  validates_attachment_content_type :verify_photo, content_type: /\Aimage\/.*\Z/

  # validate streets presence and length
  # downcase street names to ensure matching
  validates :street1, presence: true, length: { minimum: 5 }#, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }#, format: { with: VALID_STREET_REGEX }
  # validates :state, presence: true
  # validates :city, presence: true, format: { with: VALID_CITY_REGEX }

  validate :compare_location, :compare_photos, on: :update
  before_update :users_complete_project, :is_project_complete

  def compare_location
    s1 = self.changes[:street1]
    s2 = self.changes[:street2]

    unless (s1[1].to_f.between?(s1[0].to_f - 0.002, s1[0].to_f + 0.002)) && (s2[1].to_f.between?(s2[0].to_f - 0.002, s2[0].to_f + 0.002))
      errors.add(:base, "GPS Coordinates are not close enough to the original GPS coordinates, please wait a little longer for your phones GPS unit to get your location and try again.")
    end
  end

  def compare_photos
    if self.photo.queued_for_write.count != 0
      image1 = Magick::Image.read(self.photo.queued_for_write[:original].path)[0].resize(500,500)
    else
      image1 = Magick::Image.read(self.photo.path)[0].resize(500,500)
    end
    if self.verify_photo.queued_for_write.count != 0
      image2 = Magick::Image.read(self.verify_photo.queued_for_write[:original].path)[0].resize(500,500)
    else
      image2 = Magick::Image.read(self.verify_photo.path)[0].resize(500,500)
    end
    diff = image1.difference(image2)
    puts diff
    unless diff[1] <= 0.15
      errors.add(:photo, "is too different from the original, try retaking the picture and trying again. Make sure to you are taking the photo from the same device with the same camera settings (this stuff is difficult).")
    else
      self.photo = self.verify_photo
    end
  end

  def users_complete_project
    if self.errors[:base].count == 0
      self.users.each do |user|
        user.number_projects_complete += 1
      end
    end
  end

  def is_project_complete
    if self.errors[:base].count == 0
      self.complete_button_after_click = true
      self.project_complete = true
    end
  end

  # GPS version -  Returns an array of projects that are similar if project exists
  def project_exists
    if self.check_project_exists == true
      return (Project.select{ |proj| proj.project_type == self.project_type } &&
              Project.select{ |proj| proj.street1.to_f.between?((self.street1.to_f
                 - 0.02), (self.street1.to_f + 0.02))} &&
              Project.select{ |proj| proj.street2.to_f.between?((self.street2.to_f
                 - 0.02), (self.street2.to_f + 0.02 ))})
    else
      return []
    end
  end

  # GPS version - check for projects that have similar streets reversing street order as necessary.

  def check_project_exists
    # if latitude is within +/- 2 ten-thounsandths of another project's latitude it is the same
    (Project.select{ |proj| proj.project_type == self.project_type }.count > 0 && Project.select{ |proj| proj.street1.to_f.between?((self.street1.to_f - 0.002), (self.street1.to_f + 0.002))}.count > 0 && Project.select{ |proj| proj.street2.to_f.between?((self.street2.to_f - 0.02), (self.street2.to_f + 0.02))}.count > 0)
  end

  # downcase to make comparisons more accurate, but right now doesn't work properly, downcases all and saves to city field
  # before_save { self.city = city.downcase, self.street1 = street1.downcase, self.street2 = street2.downcase }

  # Returns an array of projects that are similar if project exists
  #   def project_exists
  #
  #     if self.check_project_exists == true
  #       return (Project.select{ |proj| proj.street1.similar(self.street1 || self.street2) >= 85.0 }) &&
  #       (Project.select{ |proj| proj.street2.similar(self.street2 || self.street1) >= 85.0 }) &&
  #       (Project.select{ |proj| proj.city.similar(self.city) >= 95.0 }) &&
  #       (Project.select{ |proj| proj.state == self.state }) &&
  #       (Project.select{ |proj| proj.project_type == self.project_type })
  #     else
  #       return []
  #     end
  #   end
  #
  # # check for projects that have similar streets reversing street order as necessary.
  # # checks if project exists and returns true or false
  # def check_project_exists
  #   ((Project.select{ |proj| proj.street1.similar(self.street1) >= 90.0 }.count > 0) || (Project.select{ |proj| proj.street1.similar(self.street2) >= 90.0 }.count > 0)) &&
  #   ((Project.select{ |proj| proj.street2.similar(self.street1) >= 90.0 }.count > 0) || (Project.select{ |proj| proj.street1.similar(self.street2) >= 90.0 }.count > 0)) &&
  #   (Project.select{ |proj| proj.city.similar(self.city) >= 95.0 }.count > 0) &&
  #   (Project.select{ |proj| proj.state == self.state }.count > 0) &&
  #   (Project.select{ |proj| proj.project_type == self.project_type }.count > 0)
  # end

  # if streets aren't different, new proj page will be rendered again, cross streets can't be the same street
  # def streets_are_not_different
  #   self.street1.downcase
  #   self.street2.downcase
  #   if (self.street1).similar(self.street2) >= 80.0
  #     return true
  #   end
  # end

  # rubular.com
  # VALID_STREET_REGEX = /\A\d{0,6}([s][t]|[t][h]|[r][d]){0,2}\s{0,1}[a-zA-Z]{1,50}.{0,1}\s{1}[a-zA-Z]{0,50}.{0,1}\s{0,1}[a-zA-Z]{0,50}.{0,1}[a-zA-Z]{2}.{0,1}$\z/

  # VALID_CITY_REGEX = /\A[a-zA-Z][a-z]{3,20}(\s?|-?)[a-z]{0,20}(\s?|-?)[a-z]{0,20}(\s?|-?)[a-z]{0,20}\z/

  # used this one not needed with gps
  # VALID_CITY_REGEX = /\A[a-zA-Z]+(?:(?:\s+|-)[a-zA-Z]+)*\z/
end
