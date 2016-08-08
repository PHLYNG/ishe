class AddAttachmentColumnsToUsers < ActiveRecord::Migration
  def change
    add_attachment :projects, :project_image
  end
end
