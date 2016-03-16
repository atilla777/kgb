class JobPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        Job.all
      else
        organizations_ids = OrganizationPolicy::Scope.
          new(@user, Organization).resolve.pluck(:id)
        Job.where("organization_id IN (#{organizations_ids.join(', ')})")
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
    if scope.where(:id => record.id).exists?
      true
    elsif
      @user.has_any_role? :admin, :editor, :viewer, :organization_editor, :organization_viewer
    else
      false
    end
  end

end
