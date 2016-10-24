class DjManagerController < ApplicationController
  def index
    authorize :dj_manager
    @tasks = Delayed::Job.all
  end

  def show
    authorize :dj_manager
    @task = Delayed::Job.where(id: params[:id]).first
    redirect_to dj_index_path unless @task
  end

  def destroy
    authorize :dj_manager
    task = Delayed::Job.where(id: params[:id]).where('locked_by IS NULL').first
    task.destroy if task
    redirect_to dj_index_path
  end

  def create_planner
    authorize :dj_manager
    planner = Delayed::Job.where(queue: 'planner').first
    if planner.blank?
      DailyPlannerJob.perform_later
    end
    redirect_to dj_index_path
  end

  def destroy_all
    authorize :dj_manager
    Delayed::Job.where('locked_by IS NULL').destroy_all
    redirect_to dj_index_path
  end
end
