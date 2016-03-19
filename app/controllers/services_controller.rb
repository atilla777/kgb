class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy, :legalise, :unlegalise]
  before_action :set_organizations, only: [:new, :create, :edit, :update, :legalise, :unlegalise]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    if params[:service].present?
      @service = Service.new(organization_id: params[:service][:organization_id], host: params[:service][:host], port: params[:service][:port], protocol: params[:service][:protocol])
    else
      @service = Service.new
    end
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        flash[:success] = t('flashes.create', model: Service.model_name.human)
        format.html { redirect_to @service}
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def legalise
    @service.update_attribute :legality, 1
    render 'detected_services_renew'
  end

  def unlegalise
    @service.update_attribute :legality, 0
    render 'detected_services_renew'
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        flash[:success] = t('flashes.update', model: Service.model_name.human)
        format.html { redirect_to @service}
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: Service.model_name.human)
      format.html { redirect_to services_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    def set_organizations
      @organizations = policy_scope(Organization).order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:name, :organization_id, :legality, :host, :port, :protocol, :description)
    end
end
