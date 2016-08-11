class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  has_many :project_comments, dependent: :destroy

  before_save { self.street1 = street1.downcase, self.street2 = street2.downcase }
  before_save { streets_are_different }

  has_attached_file :photo,
  styles: { large: "500x500>", medium: "300x300>", thumb: "100x100>" },
  :url => "/assets/projects/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"

  # rubular.com
  VALID_STREET_REGEX = /\A\d{0,6}([s][t]|[t][h]|[r][d]){0,2}\s{0,1}[a-zA-Z]{1,50}.{0,1}\s{1}[a-zA-Z]{0,50}.{0,1}\s{0,1}[a-zA-Z]{0,50}.{0,1}[a-zA-Z]{2}.{0,1}$\z/

  # validate streets presence and length
  # downcase street names to ensure matching
  validates :street1, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  def streets_are_different
    self.street1.downcase
    self.street2.downcase
    if self.street1 == self.street2
      flash[:warning] = "Street names cannot be identical."
      render 'new'
    end
  end

  # Validate filename
  validates :photo, attachment_presence: true
  validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  def english_date
    database_date = self.project_action_date
    database_date.strftime("%a %b #{database_date.day.ordinalize}")
  end


  # add user to list of users on project for display on project page (not currently in migration )
  # def add_user(user)
  #   unless self.user_projects.include?user.email
  #     self.user_projects << user.user_first_name + " " + user.user_last_name
  #   end
  # end

  # not needed with find_or_create_by method in controller
  # still need to create Team

  # def check_project_exists
  #   # for merging two or more projects together
  #   binding.pry
  #   if Project.exists?(project_type: self.project_type, street1: self.street1, street2: self.street2) ||
  #
  #   Project.exists?(project_type: self.project_type, street1: self.street2, street2: self.street1)
  #
  #   return UserJoinProject.create(
  #                 project_type: check_project_exists.project_type,
  #                 street1: check_project_exists.street1,
  #                 street2: "E St." )
  #     # Team.create(project_id: new_proj.id, users: [current_user, get_users_for_new_team )
  #   end
  # end



  # def get_users_for_new_team
  #   users_for_team = []
  #   check_project_exists.users.each do |user|
  #     users_for_team.push(user)
  #   end
  #   return users_for_team
  # end

  # before create, check if project exists already.
  # if project exits, then count projects
  # if number of same projects if >= 5 then create team
end
