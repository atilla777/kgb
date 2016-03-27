class OptionSetPolicy < ApplicationPolicy

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

  def show?
    if @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
      true
    else
      false
    end
  end

  def new?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def create?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def edit?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def update?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

  def destroy?
    if @user.has_any_role? :admin, :editor
      true
    else
      false
    end
  end

end
