class Note < ApplicationRecord
  belongs_to :trail
  belongs_to :author, class_name: "User"

  BODY_LIMIT = 500

  validates :body, presence: true, length: { maximum: BODY_LIMIT }

  after_create_commit -> { broadcast_prepend_to trail, target: "notes" }
  after_create_commit -> { NotifyFollowersJob.perform_later(self) }
end
