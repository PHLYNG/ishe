class Project < ApplicationRecord
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects
  has_many :photos

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
  #       Project.exists?(project_type: self.project_type, street1: self.street2, street2: self.street1)
  #     return Project.create(
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
