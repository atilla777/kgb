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
    if @user.has_any_role? :admin, :editor, :viewer, :local_editor, :local_viewer
      true
    else
      false
    end
  end

  def show?
    if scope.where(:id => record.id).exists?
      true
    elsif
      @user.has_any_role? :admin, :editor, :viewer, :local_editor, :local_viewer
    else
      false
    end
  end

end
