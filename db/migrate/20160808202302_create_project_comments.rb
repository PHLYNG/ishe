class CreateProjectComments < ActiveRecord::Migration[5.0]
  def change
    create_table :project_comments do |t|
      t.text :body
      t.string :author
      t.references :project
      t.timestamps
    end
  end
end
