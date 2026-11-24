class TrailsController < ApplicationController
  allow_unauthenticated_access

  def index
    @trails = Trail.order(:name)
  end

  def show
    @trail = Trail.find(params[:id])
    @note = Note.new
  end
end
