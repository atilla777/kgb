class OptionSetsController < ApplicationController
   before_action :set_option_set, only: [:show, :edit, :update, :destroy]

  # GET /option_sets
  # GET /option_sets.json
  def index
    @option_sets = OptionSet.all
  end

  # GET /option_sets/1
  # GET /option_sets/1.json
  def show
  end

  # GET /option_sets/new
  def new
    @option_set = OptionSet.new
  end

  # GET /option_sets/1/edit
  def edit
  end

  # POST /option_sets
  # POST /option_sets.json
  def create
    @option_set = OptionSet.new(option_set_params)
    respond_to do |format|
      if @option_set.save
        flash[:success] = t('flashes.create', model: OptionSet.model_name.human)
        format.html { redirect_to @option_set}
        format.json { render :show, status: :created, location: @option_set }
      else
        format.html { render :new }
        format.json { render json: @option_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /option_sets/1
  # PATCH/PUT /option_sets/1.json
  def update
    respond_to do |format|
      if @option_set.update(option_set_params)
        flash[:success] = t('flashes.update', model: OptionSet.model_name.human)
        format.html { redirect_to @option_set}
        format.json { render :show, status: :ok, location: @option_set }
      else
        format.html { render :edit }
        format.json { render json: @option_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /option_sets/1
  # DELETE /option_sets/1.json
  def destroy
    @option_set.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: OptionSet.model_name.human)
      format.html { redirect_to option_sets_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option_set
      @option_set = OptionSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def option_set_params
      params.require(:option_set).permit(:name,
                                         :description,
                                         :options,
                                           :syn_scan,
                                           :skip_discovery,
                                           :udp_scan,
                                           :service_scan,
                                           :os_fingerprint)
    end
end
