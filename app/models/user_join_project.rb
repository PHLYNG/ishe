class UserJoinProject < ApplicationRecord
  belongs_to :user
  belongs_to :project

end




# user_join_projects (teams) is a join table between Projects and Users

# Currently I have a Projects Model
# ```
# has_many :teams, dependent: :destroy
#   has_many :users, through: :teams
# ```
#
# A User Model
# ```
# has_many :teams
#   has_many :projects, through: :teams
# ```
#
# and a Teams Model acting as a join table between Users and Projects
# ```
# belongs_to :user
#   belongs_to :project
# ```
#
# As I understand it now, each Team would then have its own unique ID for every Project/User ID on the Team Table, for example:
# ```
# ID / Project ID / User ID
# 1 / 1 / 3
# 2 / 1 / 4
# 3 / 1 / 5
# ```
# So in the above, even though Users 3, 4 and 5 are all on the same Project (1) they all belong to different Teams.
#
# I think one solution I discussed with some of you before was to create another join table, Member(ships). My question is, is it cool to make a join table with three columns? After some googling it seems that join tables only have 2 associations. Here's what I'm thinking instead of a Team join Table:
#
# Membership Join table:
# ```
# ID / Project ID / User ID / Team ID
# 1 / 1 / 3 / 1
# 2 / 1 / 4 / 1
# 3 / 1 / 5 / 1
# ```
# Each Project and Team ID is the same so why not just use the Project as the de facto "Team"?
