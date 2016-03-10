class UsersRolesController < ApplicationController

  def create
    @user.add_role(params[:role])
    set_user_roles
    respond_to do |format|
      # возращается ответ на ajax запрос (запрос со страницы сведений о работе)
      format.js {render 'user_roles_renew'}
    end
  end

  def destroy
    @user.remove_role(params[:role])
    set_user_roles
    respond_to do |format|
      # возращается ответ на ajax запрос (запрос со страницы сведений о работе)
      format.js {render 'user_roles_renew'}
    end
  end
  
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_roles
    @roles = @user.roles
    user_roles_names = @roles.map{|role| role.name.to_sym}
    @allowed_roles = User.roles.keys.select{|role_name| user_roles_names.exclude?(role_name) }
  en
  
end
