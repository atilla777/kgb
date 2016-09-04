class JobsController < ApplicationController
  before_action :set_job, only: [:scan, :show, :edit, :update, :destroy]
  before_action :set_organizations, only: [:new, :create, :edit, :update]
  before_action :set_option_sets, only: [:new, :create, :edit, :update]
  before_action :set_previous_action, only: [:new, :edit, :destroy, :scan]
  before_action :reset_previous_action, only: [:index]

  def scan
    authorize @job
    ScanJob.perform_later(params[:id])
    flash[:success] = t('flashes.run')
    redirect_to session.delete(:return_to)
  end

  # GET /jobs
  # GET /jobs.json
  def index
    authorize Job
    #
   @jobs = policy_scope(Job).includes(:organization).includes(:option_set)
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    authorize @job
    @schedules = @job.schedules
  end

  # GET /jobs/new
  def new
    authorize Job
    if params[:job].present?
      if params[:job][:organization_id].present?
        organization = Organization.find(params[:job][:organization_id])
        h = {name: organization.name,
             organization_id: organization.id,
             hosts: params[:job][:host]}
      else
        h = {}
      end
      h[:hosts] = params[:job][:host]
      @job = Job.new(h)
    else
      @job = Job.new
    end
  end

  # GET /jobs/1/edit
  def edit
    authorize @job
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    authorize @job

    respond_to do |format|
      if @job.save
        flash[:success] = t('flashes.create', model: Job.model_name.human)
        format.html { redirect_to session.delete(:return_to) || jobs_path}
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    authorize @job
    respond_to do |format|
      if @job.update(job_params)
        flash[:success] = t('flashes.update', model: Job.model_name.human)
        format.html { redirect_to session.delete(:return_to) || jobs_path}
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    authorize @job
    @job.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: Job.model_name.human)
      format.html { redirect_to session.delete(:return_to) }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  def set_organizations
    @organizations = policy_scope(Organization).order(:name)
  end

  def set_option_sets
    @option_sets = OptionSet.all.order(:name)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:name, :description, :ports, :hosts, :options, :organization_id, :option_set_id)
  end

  def set_previous_action
      session[:return_to] ||= request.env['HTTP_REFERER']
  end

  def reset_previous_action
      session.delete(:return_to)
  end
end
