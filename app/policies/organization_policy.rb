class OrganizationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        scope.all
      else
        scope.with_role(Organization.beholder_role_name, @user)
      end
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
    if @user.has_any_role? :admin, :editor
      true
    elsif @user.has_role? Organization.beholder_role_name, scope.where(id: record.id).first
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
