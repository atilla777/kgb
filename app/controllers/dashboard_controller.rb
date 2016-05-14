class DashboardController < ApplicationController

  def index
    authorize :dashboard
    @organizations = policy_scope(Organization)
    @user_active_services = current_user.jobs_active_services
  end

end
