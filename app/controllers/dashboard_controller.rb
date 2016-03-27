class DashboardController < ApplicationController

  def index
    authorize :dashboard
    @organizations = policy_scope(Organization)
  end

end
