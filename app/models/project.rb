class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  has_many :project_comments, dependent: :destroy

  before_save { self.street1 = street1.downcase, self.street2 = street2.downcase }

  has_attached_file :photo,
  styles: { large: "500x500>", medium: "300x300>", thumb: "100x100>" },
  :url => "/assets/projects/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"

  # validate streets presence and length
  # downcase street names to ensure matching

  validates :street1, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }
  validates :street2, presence: true, length: { minimum: 5 }, format: { with: VALID_STREET_REGEX }

  # http://bit.ly/2b1oiWG
  VALID_STREET_REGEX = ^(?n:(?<address1>(\d{1,5}(\ 1\/[234])?(\x20[A-Z]([a-z])+)+ )|(P\.O\.\ Box\ \d{1,5}))\s{1,2}(?i:(?<address2>(((APT|B LDG|DEPT|FL|HNGR|LOT|PIER|RM|S(LIP|PC|T(E|OP))|TRLR|UNIT)\x20\w{1,5})|(BSMT|FRNT|LBBY|LOWR|OFC|PH|REAR|SIDE|UPPR)\.?)\s{1,2})?)(?<city>[A-Z]([a-z])+(\.?)(\x20[A-Z]([a-z])+){0,2})\, \x20(?<state>A[LKSZRAP]|C[AOT]|D[EC]|F[LM]|G[AU]|HI|I[ADL N]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD] |T[NX]|UT|V[AIT]|W[AIVY])\x20(?<zipcode>(?!0{5})\d{5}(-\d {4})?))$


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
