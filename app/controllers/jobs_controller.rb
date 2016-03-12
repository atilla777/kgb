class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :set_organizations, only: [:new, :create, :edit, :update]

  def scan
    ScanJob.perform_later(params[:job_id])
    redirect_to scanned_ports_path
  end

  # GET /jobs
  # GET /jobs.json
  def index
    authorize Job
    #
    if current_user.has_any_role? :admin, :editor, :viewer
      @jobs = Job.all
    else
      organizations_ids = policy_scope(Organization).pluck(:id)
      @jobs = Job.where("organization_id IN (#{organizations_ids.join(', ')})").load
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @schedules = @job.schedules
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        flash[:success] = t('flashes.create', model: Job.model_name.human)
        format.html { redirect_to @job}
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
    respond_to do |format|
      if @job.update(job_params)
        flash[:success] = t('flashes.update', model: Job.model_name.human)
        format.html { redirect_to @job}
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
    @job.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: Job.model_name.human)
      format.html { redirect_to jobs_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    def set_organizations
      @organizations = Organization.all.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:name, :description, :ports, :hosts, :options, :organization_id)
    end
end
