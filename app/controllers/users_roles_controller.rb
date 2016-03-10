class UsersRolesController < ApplicationController

  before_filter :set_user

  def create
    authorize :users_roles
    @user.add_role(params[:role])
    set_user_roles
    respond_to do |format|
      # РІРѕР·СЂР°С‰Р°РµС‚СЃСЏ РѕС‚РІРµС‚ РЅР° ajax Р·Р°РїСЂРѕСЃ (Р·Р°РїСЂРѕСЃ СЃРѕ СЃС‚СЂР°РЅРёС†С‹ СЃРІРµРґРµРЅРёР№ Рѕ СЂР°Р±РѕС‚Рµ)
      format.js {render 'user_roles_renew'}
    end
  end

  def destroy
    authorize :users_roles
    @user.remove_role(params[:role])
    set_user_roles
    respond_to do |format|
      # РІРѕР·СЂР°С‰Р°РµС‚СЃСЏ РѕС‚РІРµС‚ РЅР° ajax Р·Р°РїСЂРѕСЃ (Р·Р°РїСЂРѕСЃ СЃРѕ СЃС‚СЂР°РЅРёС†С‹ СЃРІРµРґРµРЅРёР№ Рѕ СЂР°Р±РѕС‚Рµ)
      format.js {render 'user_roles_renew'}
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_roles
    @roles = @user.roles
    user_roles_names = @roles.map{|role| role.name.to_sym}
    @allowed_roles = User.roles.keys.select{|role_name| user_roles_names.exclude?(role_name) }
  end

end
