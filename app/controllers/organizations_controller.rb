class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :report]
  before_action :set_date, only: [:show, :report]
  before_action :set_services, only: [:show, :report]
  before_action :set_scans, only: [:show, :report]
  before_action :set_hosts, only: [:show, :report]
  before_action :set_jobs, only: [:show, :report]
  before_action :reset_previous_action, only: [:index, :show]

  # GET /organizations
  # GET /organizations.json
  def index
    authorize Organization
    @organizations = policy_scope(Organization)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize @organization
  end

  # GET /organizations/new
  def new
    authorize Organization
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    authorize @organization
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    respond_to do |format|
      if @organization.save
        flash[:success] = t('flashes.create', model: Organization.model_name.human)
        format.html { redirect_to @organization}
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize @organization
    respond_to do |format|
      if @organization.update(organization_params)
        flash[:success] = t('flashes.update', model: Organization.model_name.human)
        format.html { redirect_to @organization}
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize @organization
    @organization.destroy
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: Organization.model_name.human)
      format.html { redirect_to organizations_url}
      format.json { head :no_content }
    end
  end

  def report
    data = report_document.to_rtf
    send_data data,
      :type => 'text/rtf; charset=UTF-8; header=present',
      :disposition => "attachment; filename = Organization id-#{@organization.id} report on #{Date.today}.rtf"
  end

  private
  def reset_previous_action
      session.delete(:return_to)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_services
    @services = @organization.services
                             .where(%q|
                                        port IS NOT NULL
                                        AND protocol IS NOT NULL
                                      |)
    organization_hosts = @organization.services.group(:host).pluck(:host)
    normilized_organization_hosts = Service.normilize_hosts(organization_hosts)
    @active_services = ScannedPort.where(state: 'open')
                      .where("scanned_ports.host IN (#{normilized_organization_hosts.map{|h| "'#{h}'"}.join(', ')})")
                      .select('scanned_ports.*, s.id AS s_id, s.legality AS s_legality')
                      .joins(%Q(
                               INNER JOIN
                                 (SELECT
                                    scanned_ports.job_id,
                                    MAX(scanned_ports.job_time) AS 'max_time' FROM scanned_ports
                                  WHERE scanned_ports.job_time <= '#{@selected_date} 23:59:59'
                                  GROUP BY scanned_ports.job_id)a
                               ON a.job_id = scanned_ports.job_id
                               AND a.max_time = scanned_ports.job_time
                              )
                           )
                      .joins(%Q(
                             LEFT OUTER JOIN services AS s
                             ON s.host = scanned_ports.host
                             AND s.port = scanned_ports.port
                             AND s.protocol = scanned_ports.protocol
                             AND s.organization_id = #{@organization.id}
                             )
                            )
                      .distinct
                      .order(host: :asc)
                      .includes(:job)
  end
  
  def set_scans
    organization_hosts = @organization.services.group(:host).pluck(:host)
    normilized_organization_hosts = Service.normilize_hosts(organization_hosts)
    @scans = ScannedPort.where("scanned_ports.host IN (#{normilized_organization_hosts.map{|h| "'#{h}'"}.join(', ')})")
                      .select('scanned_ports.*, s.id AS s_id, s.legality AS s_legality')
                      .joins(%Q(
                               INNER JOIN
                                 (SELECT
                                    scanned_ports.job_id,
                                    MAX(scanned_ports.job_time) AS 'max_time' FROM scanned_ports
                                  WHERE scanned_ports.job_time <= '#{@selected_date} 23:59:59'
                                  GROUP BY scanned_ports.job_id)a
                               ON a.job_id = scanned_ports.job_id
                               AND a.max_time = scanned_ports.job_time
                              )
                           )
                      .joins(%Q(
                             LEFT OUTER JOIN services AS s
                             ON s.host = scanned_ports.host
                             AND s.port = scanned_ports.port
                             AND s.protocol = scanned_ports.protocol
                             AND s.organization_id = #{@organization.id}
                             )
                            )
                      .distinct
                      .order(host: :asc)
                      .includes(:job)
  end

  def set_hosts
    @hosts = Service.where(organization_id: @organization.id)
                    .where('services.port IS NULL')
                    .all
                    .order(:host)
  end

  def set_jobs
    @jobs = policy_scope(Job).where(organization_id: @organization.id).includes(:option_set)
  end

  def set_date
    @selected_date = params[:selected_date] || Date.today
  end

  # make rtf document and configure its settings
  def report_document
    # document settings
    document_style = RTF::DocumentStyle.new
    document_style.orientation = RTF::DocumentStyle::LANDSCAPE
    document_style.paper = RTF::Paper::A4
    document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'), document_style)

    # header settings
    header_style = RTF::ParagraphStyle.new
    header_style.justification = RTF::ParagraphStyle::CENTER_JUSTIFY
    header_font_style = RTF::CharacterStyle.new
    header_font_style.bold = true
    header_font_style.font_size = 24

    # text settings
    text_font_style = RTF::CharacterStyle.new
    text_font_style.font_size = 24
    text_style = RTF::ParagraphStyle.new
    text_style.justification = RTF::ParagraphStyle::FULL_JUSTIFY
    text_style.first_line_indent = 400

    document.paragraph(header_style).apply(header_font_style) << "Отчет о сетевых ресурсах организации #{@organization.name}"
    document.paragraph(header_style).apply(text_font_style) << <<-TEXT
      (отчет сгенерирован #{Time.now.strftime('%d.%m.%Y')}, открытые порты по состоянию на #{DateTime.parse(@selected_date).strftime('%d.%m.%Y')})
    TEXT

    document.paragraph(text_style).line_break
    document.paragraph(text_style).apply(header_font_style) << 'Открытые порты организации:'
    table_params = [@active_services.size + 1, 11, 500, 800, 1500, 1400, 1000, 1300, 1600, 1700, 2000, 1200, 1200]
    table = document.table(*table_params)
    table.border_width = 5

    table[0][0].apply(header_font_style)  << "№ п.п."
    table[0][1].apply(header_font_style)  << "Порт"
    table[0][2].apply(header_font_style)  << "Состояние"
    table[0][3].apply(header_font_style)  << "Протокол"
    table[0][4].apply(header_font_style)  << "Сервис"
    table[0][5].apply(header_font_style)  << "ПО"
    table[0][6].apply(header_font_style)  << "Хост"
    table[0][7].apply(header_font_style)  << "Время сканирования"
    table[0][8].apply(header_font_style)  << "Название работы"
    table[0][9].apply(header_font_style)  << "Легал. в наст. вр."
    table[0][10].apply(header_font_style)  << "Легал. в мом. скан."
    @active_services.each_with_index do | service, i |
      table[i + 1][0] << "#{i + 1}."
      table[i + 1][1] << service.port.to_s
      table[i + 1][2] << service.show_state
      table[i + 1][3] << service.protocol
      table[i + 1][4] << service.service
      if service.product.present?
        table[i + 1][5] << service.product
      end
      table[i + 1][6] << service.host
      table[i + 1][7] << service.job_time.strftime("%d.%m.%Y-%H.%m.%S").to_s
      table[i + 1][8] << service.job.name
      table[i + 1][9] << Service.show_legality(service.s_legality)
      table[i + 1][10] << service.show_legality
    end
    document.paragraph(text_style).line_break
    document.paragraph(header_style).apply(header_font_style) << "Дополнительные сведения"

    document.paragraph(text_style).line_break
    document.paragraph(text_style).apply(header_font_style) << 'Открытые порты организации:'
    @active_services.each_with_index do |service, i|
      document.paragraph(text_style).apply(text_font_style) << <<-TEXT
        #{i + 1}. порт - #{service.port}, 
        состояние - #{service.show_state}, 
        хост - #{service.host}, 
        протокол - #{service.protocol}, 
        сервис - #{service.service}, 
        ПО - #{service.product.present? ? service.show_product : 'не известно'}, 
        время сканирования - #{service.job_time.strftime("%d.%m.%Y-%H.%m.%S")}, 
        название работы - #{service.job.name}, 
        легальность - #{Service.show_legality(service.s_legality)}, 
        легальность на момент сканирования - #{service.show_legality}.
      TEXT
    end

    document.paragraph(text_style).line_break
    document.paragraph(text_style).apply(header_font_style) << 'Сервисы организации:'
    @services.each_with_index do |service, i|
      document.paragraph(text_style).apply(text_font_style) << <<-TEXT
        #{i + 1}. #{service.name}: 
        порт - #{service.port}, 
        хост - #{service.host}, 
        протокол - #{service.protocol}, 
        легален - #{service.show_legality}.
      TEXT
    end

    document.paragraph(text_style).line_break
    document.paragraph(text_style).apply(header_font_style) << 'Хосты организации:'
    @hosts.each_with_index do |host, i|
      document.paragraph(text_style).apply(text_font_style) << "#{i + 1}. #{host.host} (#{host.name})."
    end

    document
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
