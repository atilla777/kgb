class DashboardController < ApplicationController

  def index
    @organizations = policy_scope(Organization)
  end

end
