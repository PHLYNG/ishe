class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  has_many :project_comments, dependent: :destroy

  # downcase to make comparisons more accurate, but right now doesn't work properly, downcases all and saves to city field
  # before_save { self.city = city.downcase, self.street1 = street1.downcase, self.street2 = street2.downcase }

  has_attached_file :photo,
  styles: { large: "500x500>", medium: "200x200>", thumb: "100x100>" },
  :url => "/assets/projects/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"

  # rubular.com
  VALID_STREET_REGEX = /\A\d{0,6}([s][t]|[t][h]|[r][d]){0,2}\s{0,1}[a-zA-Z]{1,50}.{0,1}\s{1}[a-zA-Z]{0,50}.{0,1}\s{0,1}[a-zA-Z]{0,50}.{0,1}[a-zA-Z]{2}.{0,1}$\z/

  # VALID_CITY_REGEX = /\A[a-zA-Z][a-z]{3,20}(\s?|-?)[a-z]{0,20}(\s?|-?)[a-z]{0,20}(\s?|-?)[a-z]{0,20}\z/
  VALID_CITY_REGEX = /\A[a-zA-Z]+(?:(?:\s+|-)[a-zA-Z]+)*\z/

  validates :project_type, presence: true

  # validate streets presence and length
  # downcase street names to ensure matching
  validates :street1, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :state, presence: true
  validates :city, presence: true, format: { with: VALID_CITY_REGEX }

  # if streets aren't different, new proj page will be rendered again, cross streets can't be the same street
  def streets_are_not_different
    self.street1.downcase
    self.street2.downcase
    if (self.street1).similar(self.street2) >= 80.0
      return true
    end
  end

  # Returns an array of projects that are similar if project exists
    def project_exists
      binding.pry
      if self.check_project_exists == true
        return (Project.select{ |proj| proj.street1.similar(self.street1 || self.street2) >= 80.0 }) &&
        (Project.select{ |proj| proj.street2.similar(self.street2 || self.street1) >= 80.0 }) &&
        (Project.select{ |proj| proj.city.similar(self.city) >= 95.0 }) &&
        (Project.select{ |proj| proj.state == self.state }) &&
        (Project.select{ |proj| proj.project_type == self.project_type })
      else
        return []
      end
    end

  # check for projects that have similar streets reversing street order as necessary.
  # checks if project exists and returns true or false
  def check_project_exists
    (Project.select{ |proj| proj.street1.similar(self.street1 || self.street2) >= 90.0 }.count > 0) &&
    (Project.select{ |proj| proj.street2.similar(self.street2 || self.street1) >= 90.0 }.count > 0) &&
    (Project.select{ |proj| proj.city.similar(self.city) >= 95.0 }.count > 0) &&
    (Project.select{ |proj| proj.state == self.state }.count > 0) &&
    (Project.select{ |proj| proj.project_type == self.project_type }.count > 0)
  end

  # Validate filename
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
