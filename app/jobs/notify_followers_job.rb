class NotifyFollowersJob < ApplicationJob
  def perform(note)
    note.trail.followers.where.not(id: note.author_id).find_each do |follower|
      NoteMailer.with(note:, follower:).new_note.deliver_now
    end
  end
end
