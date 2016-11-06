class DjManagerPolicy < ApplicationPolicy
  def index?
    if @user.has_role? :admin
      true
    else
      false
    end
  end

  def show?
    if @user.has_role? :admin
      true
    else
      false
    end
  end

  def destroy?
    if @user.has_role? :admin
      true
    else
      false
    end
  end

  def destroy_all?
    if @user.has_role? :admin
      true
    else
      false
    end
  end

  def create_planner?
    if @user.has_role? :admin
      true
    else
      false
    end
  end
end
