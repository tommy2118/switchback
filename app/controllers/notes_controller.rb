class NotesController < ApplicationController
  before_action :set_trail

  def create
    @note = Note.new(note_params.merge(trail: @trail, author: Current.user))
    if @note.save
      redirect_to @trail, notice: "Note posted."
    else
      render "trails/show", status: :unprocessable_content
    end
  end

  private
    def set_trail
      @trail = Trail.find(params[:trail_id])
    end

    def note_params
      params.expect(note: [ :body ])
    end
end
