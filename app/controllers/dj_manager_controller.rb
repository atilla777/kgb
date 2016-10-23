class DjManagerController < ApplicationController
  def index
    @tasks = Delayed::Job.all
  end

  def show
    @task = Delayed::Job.find(params[:id])
  end

  def destroy
    task = Delayed::Job.find(params[:id])
    task.destroy
    redirect_to dj_index_path
  end
end
