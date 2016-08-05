class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :project_type
      t.string :street1
      t.string :street2
      t.boolean :project_complete
      t.date :project_action_date

      t.timestamps
    end
  end
end
