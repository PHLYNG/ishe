class Project < ApplicationRecord
  # belongs_to :team
  # has_one :team
  # belongs_to :user
  has_many :user_join_projects, dependent: :destroy
  has_many :users, through: :user_join_projects

  before_create :check_project_exists
  after_create :create_new_project

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

  def check_project_exists
    # for merging two or more projects together
    if Project.exists?(project_type: "Pothole", street1: "C St.", street2: "D St.")
      return self
    end
  end
  # binding.pry
  def create_new_project
    if check_project_exists == true
      proj = Project.create(:project_type => "Pothole", :street1 => "C St.", :street2 => "D St.")
      Team.create

    end
  end

  # before create, check if project exists already.
  # if project exits, then count projects
  # if number of same projects if >= 5 then create team
end
