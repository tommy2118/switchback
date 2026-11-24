class NotesController < ApplicationController
  before_action :set_trail

  def create
    @note = @trail.notes.new(note_params)
    @note.author = Current.user
    @note.save
    redirect_to @trail, notice: "Note posted."
  end

  private
    def set_trail
      @trail = Trail.find(params[:trail_id])
    end

    def note_params
      params.expect(note: [ :body ])
    end
end
