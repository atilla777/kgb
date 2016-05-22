class DashboardController < ApplicationController

  def index
    authorize :dashboard
  end

  def detected_services
    authorize :dashboard
    @user_active_services = current_user.jobs_active_services
  end

  def new_services
    authorize :dashboard
    @user_active_services = current_user.jobs_active_services
  end

  def hosts
    authorize :dashboard
    @organizations = policy_scope(Organization)
  end

end
