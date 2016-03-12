class UsersRolesController < ApplicationController

  before_filter :set_user

  def create
    authorize :users_roles
    if params[:organization_id].present?
      organization = Organization.find(params[:organization_id])
      @user.add_role(Organization.beholder_role_name, organization)
      set_user_roles
      respond_to do |format|
        format.js {render 'organization_roles_renew'}
      end
    else
      @user.add_role(params[:role])
      set_user_roles
      respond_to do |format|
        format.js {render 'user_roles_renew'}
      end
    end
  end

  def destroy
    authorize :users_roles
    if params[:organization_id].present?
      organization = Organization.find(params[:organization_id])
      @user.remove_role(Organization.beholder_role_name, organization)
      set_user_roles
      respond_to do |format|
        format.js {render 'organization_roles_renew'}
      end
    else
      @user.remove_role(params[:role])
      set_user_roles
      respond_to do |format|
        format.js {render 'user_roles_renew'}
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_roles
    # глобальные роли
    @roles = @user.roles
    user_roles_names = @roles.map{|role| role.name.to_sym}
    @allowed_roles = User.roles.keys.select{|role_name| user_roles_names.exclude?(role_name) }
    # роли организации (к информации каких организаций  имеет доступ пользователь)
    @assigned_organizations = Organization.with_role(Organization.beholder_role_name, @user)
    @allowed_organizations = Organization.all
    @allowed_organizations = @allowed_organizations.select{ |organization| @assigned_organizations.exclude?(organization) }
  end

end
