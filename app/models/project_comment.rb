class ProjectComment < ApplicationRecord
  belongs_to :project

  validates :body, presence: true, length: { minimum: 2 }
end
