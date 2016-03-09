class UsersRolesController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    @user.add_role(params[:role])
    @roles = @user.roles
    @allowed_roles = User.roles.keys
    respond_to do |format|
      # возращается ответ на ajax запрос (запрос со страницы сведений о работе)
      format.js {render 'user_roles_renew'}
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.remove_role(params[:role])
    @roles = @user.roles
    @allowed_roles = User.roles.keys - @roles
    respond_to do |format|
      # возращается ответ на ajax запрос (запрос со страницы сведений о работе)
      format.js {render 'user_roles_renew'}
    end
  end
end
