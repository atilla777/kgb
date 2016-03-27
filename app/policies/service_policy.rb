class ServicePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        Service.all
      else
        organizations_ids = OrganizationPolicy::Scope.
          new(@user, Organization).resolve.pluck(:id)
        Service.where("organization_id IN (#{organizations_ids.join(', ')})")
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
    if @user.has_any_role? :admin, :editor, :viewer
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

  def new?
    if @user.has_any_role? :admin, :editor, :organization_editor
      true
    else
      false
    end
  end

  def create?
    if @user.has_any_role? :admin, :editor
      true
    elsif OrganizationPolicy::Scope.new(@user, Organization).resolve.where(id: record.organization_id).exists?
      true
    else
      false
    end
  end

  def edit?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

  def update?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

  def destroy?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

  def legalise?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

  def unlegalise?
    if @user.has_any_role? :admin, :editor
      true
    elsif scope.where(id: record.id).exists?
      true
    else
      false
    end
  end

end
