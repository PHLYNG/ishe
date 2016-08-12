class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  has_many :project_comments, dependent: :destroy

  # before_save { streets_are_different }

  has_attached_file :photo,
  styles: { large: "500x500>", medium: "300x300>", thumb: "100x100>" },
  :url => "/assets/projects/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"

  # Validate filename
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  # rubular.com
  VALID_STREET_REGEX = /\A\d{0,6}([s][t]|[t][h]|[r][d]){0,2}\s{0,1}[a-zA-Z]{1,50}.{0,1}\s{1}[a-zA-Z]{0,50}.{0,1}\s{0,1}[a-zA-Z]{0,50}.{0,1}[a-zA-Z]{2}.{0,1}$\z/

  # validate streets presence and length
  # downcase street names to ensure matching
  validates :street1, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }

  # def streets_are_different
  #   self.street1.downcase
  #   self.street2.downcase
  #  WTF can't I use this if statement to do stuff in the model? Can't call flash or render either
  #   if FuzzyMatch.new([self.street1]).find(self.street2)
  #     return false
  #     # flash[:warning] = "Street names cannot be identical."
  #     # render 'new'
  #   end
  # end


end
