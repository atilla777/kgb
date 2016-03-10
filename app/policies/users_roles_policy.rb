class UsersRolesPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    @user.has_role? :admin
  end

  def destroy?
    @user.has_role? :admin
  end
  
end
