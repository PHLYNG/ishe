class Project < ApplicationRecord
  # belongs_to :team
  # has_one :team
  # belongs_to :user
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  before_create :create_new_project

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

  def check_project_exists(proj)
    # for merging two or more projects together
    if self == Project.where( project_type: "Pothole",
                      street1: "C St.",
                      street2: "D St." ).exists?   ||

        self == Project.where(project_type: "Pothole",
                      street1: "D St.",
                      street2: "C St." ).exists?
      binding.pry
      return self
    end
  end
  # binding.pry
  def create_new_project
    debugger
    if check_project_exists(self) == true

      # new_proj =
      Project.create(
                  project_type: check_project_exists.project_type,
                  street1: check_project_exists.street1,
                  street2: "E St.")
                  # street2: check_project_exists.street2 )

      # Team.create(project_id: new_proj.id,
                  # users: [current_user, get_users_for_new_team )
    end
  end

  def get_users_for_new_team
    users_for_team = []
    check_project_exists.users.each do |user|
      users_for_team.push(user)
    end
    return users_for_team
  end

  # before create, check if project exists already.
  # if project exits, then count projects
  # if number of same projects if >= 5 then create team
end
