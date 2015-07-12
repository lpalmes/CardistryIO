class NotificationsController < ApplicationController
  before_action :require_login

  def index
    # TODO: Introduce facade
    @user = current_user
    @notifications = current_user.new_notifications
  end

  def mark_all_read
    current_user.notifications.each(&:seen!)
    flash.notice = "Marked all as read"
    redirect_to root_path
  end
end
