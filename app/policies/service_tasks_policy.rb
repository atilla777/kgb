class ServiceTasksPolicy < ApplicationPolicy

  def index?
    if @user.has_any_role? :admin
      true
    else
      false
    end
  end

  def clean_base?
    if @user.has_any_role? :admin
      true
    else
      false
    end
  end

  def sqlite_backup?
    if @user.has_any_role? :admin
      true
    else
      false
    end
  end
end
