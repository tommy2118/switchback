class FollowsController < ApplicationController
  before_action :set_trail

  def create
    @trail.follows.find_or_create_by!(user: Current.user)
    redirect_to @trail, notice: "You'll get an email about each new note."
  end

  def destroy
    @trail.follows.where(user: Current.user).destroy_all
    redirect_to @trail, notice: "You stopped following #{@trail.name}."
  end

  private
    def set_trail
      @trail = Trail.find(params[:trail_id])
    end
end
