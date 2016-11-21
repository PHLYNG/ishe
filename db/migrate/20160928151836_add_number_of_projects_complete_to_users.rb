class AddNumberOfProjectsCompleteToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :number_projects_complete, :integer, default: 0
  end
end
