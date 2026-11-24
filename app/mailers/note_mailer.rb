class NoteMailer < ApplicationMailer
  def new_note
    @note, @follower = params[:note], params[:follower]
    mail to: @follower.email_address, subject: "New note on #{@note.trail.name}"
  end
end
