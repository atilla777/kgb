class DjManagerPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if @user.has_any_role? :admin, :editor, :viewer
        Delayed::Job.all
      else
        organizations_ids = OrganizationPolicy::Scope.
          new(@user, Organization).resolve.pluck(:id)
        jobs_ids = Job.where("organization_id IN (#{organizations_ids.join(', ')})").pluck(:id)
        result = []
        Delayed::Job.all.each do |delayed_job|
          job_data = YAML.load(delayed_job.handler).job_data
          if job_data['job_class'] == 'ScanJob'
            s = job_data['arguments'][0]['_aj_globalid']
            job_id = /\d+$/.match(s)[0].to_i
            if jobs_ids.include? job_id
              result << delayed_job
            end
          end
        end
        result
      end
    end
  end

  def index?
    #if @user.has_role? :admin
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

  def destroy?
    if @user.has_any_role? :admin, :organization_editor
      true
    else
      false
    end
  end

  def destroy_all?
    if @user.has_any_role? :admin
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
