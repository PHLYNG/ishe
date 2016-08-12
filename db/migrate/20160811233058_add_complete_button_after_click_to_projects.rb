class AddCompleteButtonAfterClickToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :complete_button_after_click, :boolean
  end
end
