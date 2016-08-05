module UsersHelper
  def select_user_proj
    @user.user_join_projects.select{ |proj| proj.user_id == current_user.id }
  end
end
