class DashboardPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

  def detected_services?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

  def new_services?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

  def hosts?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

end
