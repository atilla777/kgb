class ScannedPortsController < ApplicationController
  before_action :set_scanned_port, only: [:show, :edit, :update, :destroy]

  # ++ paginate
  # для использования вместе с хелпером в application_helper
  # dt_big_table(params)
  # и view datatable.json.erb
  def datatable
    allowed_jobs_ids = policy_scope(ScannedPort).pluck(:id)
    fields = [{field: 'scanned_ports.job_time', as: 'job_time'},
              {field: 'scanned_ports.id', as: 'id', invisible: true},
              {field: 'scanned_ports.job_id', as: 'job_id', invisible: true, filter: "jobs.id IN (#{allowed_jobs_ids.join(',')})"},
              {field: 'jobs.name', as: 'job_name', joins: 'jobs', on: 'jobs.id = scanned_ports.job_id'},
              {field: 'scanned_ports.host', as: 'host'},
              {field: 'scanned_ports.port', as: 'port'},
              {field: 'scanned_ports.protocol', as: 'protocol'},
              {field: 'scanned_ports.state', as: 'port_state', map_to: ScannedPort.states},
              {field: 'scanned_ports.state', as: 'state_id', invisible: true},
              #{field: 'services.legality', as: 'service_legality'},
              {field: 'services.legality', as: 'service_legality',
map_by_sql:  "CASE
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              IS NULL AND (scanned_ports.state == 'open' OR scanned_ports.state == 'filtered')
              THEN '#{t('types.unknown')}'
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              = 0 AND (scanned_ports.state == 'open' OR scanned_ports.state == 'filtered') THEN '#{t('types.illegal')}'
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              = 1 THEN '#{t('types.legal')}'
              ELSE '#{t('types.no_sense')}' END"
              },
              {field: 'services.legality', as: 'service_legality_id', invisible: true,
map_by_sql:  "CASE
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              IS NULL AND (scanned_ports.state == 'open' OR scanned_ports.state == 'filtered') THEN 2
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              = 0 AND (scanned_ports.state == 'open' OR scanned_ports.state == 'filtered') THEN 0
              WHEN (SELECT services.legality FROM services WHERE services.host = scanned_ports.host AND services.port = scanned_ports.port)
              = 1 THEN 1
              ELSE 3 END"
              },
               {field: 'scanned_ports.legality', as: 'history_legality', map_to: ScannedPort.legalities},
               {field: 'scanned_ports.legality', as: 'history_legality_id', invisible: true},
              {field: 'scanned_ports.service', as: 'service'}]
              #{field: 'users.name', as: 'registrator', joins: 'users', on: 'incidents.user_id = users.id'}
              #{field: 'organizations.name', as: 'organization_name', joins: 'organizations', on: 'incidents.organization_id = organizations.id'},
              #{field: 'organizations.id', as: 'organization_id', invisible: true},
              #{field: 'incidents.violator', as: 'violator_name', map_by_sql:  "CASE WHEN incidents.violator IS NULL OR incidents.violator = '' THEN (SELECT users.name FROM user_incidents LEFT JOIN users ON users.id = user_incidents.user_id WHERE user_incidents.incident_id = incidents.id AND user_incidents.role = 0 AND lower(users.name) LIKE '%%' LIMIT 1) ELSE incidents.violator END"},
    @datatable = ScannedPort.dt_all(params, fields)
    respond_to do |format|
      format.json {render 'datatable'}
    end
  end

  # GET /scanned_ports
  # GET /scanned_ports.json
  def index
    authorize ScannedPort
    #@scanned_ports = ScannedPort.all#.order(job_time: :asc)
  end

  # GET /scanned_ports/1
  # GET /scanned_ports/1.json
  def show
  end

  # GET /scanned_ports/new
  def new
    @scanned_port = ScannedPort.new
  end

  # GET /scanned_ports/1/edit
  def edit
  end

  # POST /scanned_ports
  # POST /scanned_ports.json
  def create
    @scanned_port = ScannedPort.new(scanned_port_params)

    respond_to do |format|
      if @scanned_port.save
        format.html { redirect_to @scanned_port, notice: 'Scanned port was successfully created.' }
        format.json { render :show, status: :created, location: @scanned_port }
      else
        format.html { render :new }
        format.json { render json: @scanned_port.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scanned_ports/1
  # PATCH/PUT /scanned_ports/1.json
  def update
    respond_to do |format|
      if @scanned_port.update(scanned_port_params)
        format.html { redirect_to @scanned_port, notice: 'Scanned port was successfully updated.' }
        format.json { render :show, status: :ok, location: @scanned_port }
      else
        format.html { render :edit }
        format.json { render json: @scanned_port.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scanned_ports/1
  # DELETE /scanned_ports/1.json
  def destroy
    @scanned_port.destroy
    respond_to do |format|
      format.html { redirect_to scanned_ports_url, notice: 'Scanned port was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scanned_port
      @scanned_port = ScannedPort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scanned_port_params
      params.require(:scanned_port).permit(:job_time, :organization_id, :host, :port, :protocol, :state, :service)
    end
end
