class AddVerifyPhotoToProjects < ActiveRecord::Migration[5.0]
  def self.up
    change_table :projects do |t|
      t.attachment :verify_photo
    end
  end

  def self.down
    remove_attachment :projects, :verify_photo
  end
end
