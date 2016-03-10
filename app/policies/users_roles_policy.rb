class UsersRolesPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    @user.has_role? :admin
  end

  def create?
    @user.has_role? :admin
  end

  def destroy?
    @user.has_role? :admin
  end

end
