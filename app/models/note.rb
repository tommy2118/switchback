class Note < ApplicationRecord
  belongs_to :trail
  belongs_to :author, class_name: "User"

  validates :body, presence: true, length: { maximum: 500 }

  after_create_commit -> { broadcast_prepend_to trail, target: "notes" }
  after_create_commit -> { NotifyFollowersJob.perform_later(self) }
end
