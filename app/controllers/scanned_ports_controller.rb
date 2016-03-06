class ScannedPortsController < ApplicationController
  before_action :set_scanned_port, only: [:show, :edit, :update, :destroy]

  # GET /scanned_ports
  # GET /scanned_ports.json
  def index
    @scanned_ports = ScannedPort.all#.order(job_time: :asc)
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
      params.require(:scanned_port).permit(:job_time, :organization_id, :host_ip, :number, :protocol, :state, :service)
    end
end
