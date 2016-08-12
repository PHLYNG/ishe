class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  has_many :project_comments, dependent: :destroy

  # before_save { streets_are_different }

  has_attached_file :photo,
  styles: { large: "500x500>", medium: "300x300>", thumb: "100x100>" },
  :url => "/assets/projects/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"

  # rubular.com
  VALID_STREET_REGEX = /\A\d{0,6}([s][t]|[t][h]|[r][d]){0,2}\s{0,1}[a-zA-Z]{1,50}.{0,1}\s{1}[a-zA-Z]{0,50}.{0,1}\s{0,1}[a-zA-Z]{0,50}.{0,1}[a-zA-Z]{2}.{0,1}$\z/

  validates :project_type, presence: true

  # validate streets presence and length
  # downcase street names to ensure matching
  validates :street1, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }

  def streets_are_not_different
    self.street1.downcase
    self.street2.downcase
    # if FuzzyMatch.new([self.street1]).find(self.street2)
    if self.street1 == self.street2
      return true
    end
  end

  # def project_exists
      # ||
      # Project.exists?(
      #   project_type: self.project_type,
      #   street1: FuzzyMatch.new(Project.all, :read => :street1).find(self.street1),
      #   street2: FuzzyMatch.new(Project.all, :read => :street2).find(self.street2))
      # return true
    # end
  # end

  # Validate filename
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/


end
