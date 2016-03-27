class SchedulePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        Schedule.all
      else
        jobs_ids = JobPolicy::Scope.new(@user, Job).resolve.pluck(:id)
        Schedule.where("job_id IN (#{jobs_ids.join(', ')})")
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

  def create?
    if @user.has_any_role? :admin, :editor
      true
    elsif JobPolicy::Scope.new(@user, Job).resolve.where(id: record.job_id).exists?
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

end
