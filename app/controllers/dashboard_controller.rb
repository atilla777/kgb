class DashboardController < ApplicationController

  def index
    authorize :dashboard
  end

  def detected_services
    authorize :dashboard
    @user_active_services = current_user.jobs_active_services
  end

  def datatable
    authorize :dashboard
    allowed_jobs_ids = current_user.jobs.pluck(:id)
    allowed_hosts = current_user.services_hosts

    fields = [{field: 'scanned_ports.job_time', as: 'job_time'},
              {field: 'scanned_ports.id', as: 'id', invisible: true, sql_joins: %q(
                                                                         INNER JOIN (SELECT scanned_ports.job_id,
                                                                         MAX(scanned_ports.job_time)
                                                                         AS 'max_time' FROM scanned_ports
                                                                         GROUP BY scanned_ports.job_id)a
                                                                         ON a.job_id = scanned_ports.job_id
                                                                         AND a.max_time = scanned_ports.job_time
                                                                        )},
              {field: 'organizations.id', as: 'organization_id', invisible: true,},
              {field: 'organizations.name', as: 'organization_name', joins: 'organizations', on: 'organizations.id = scanned_ports.organization_id'},
              {field: 'scanned_ports.job_id', as: 'job_id', invisible: true, filter: "scanned_ports.job_id IN (#{allowed_jobs_ids.join(',')})"},
              {field: 'jobs.name', as: 'job_name', joins: 'jobs', on: 'jobs.id = scanned_ports.job_id'},
              {field: 'scanned_ports.host', as: 'sp_host', filter: "scanned_ports.host IN (#{allowed_hosts.map{ |s|  "'#{s}'"}.join(',')})"},
              {field: 'scanned_ports.port', as: 'sp_port'},
              {field: 'scanned_ports.protocol', as: 'sp_protocol'},
              {field: 'scanned_ports.state', as: 'port_state', map_to: ScannedPort.states},
              {field: 'scanned_ports.state', as: 'state_id', invisible: true, filter: "scanned_ports.state = 'open'"},
              {field: 'services.id', as: 'service_id', invisible: true, joins: 'services',
               on: 'scanned_ports.port = services.port AND scanned_ports.host = services.host AND scanned_ports.protocol = services.protocol'},
              {field: 'services.name', as: 'service_name', invisible: true},
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
              {field: 'scanned_ports.service', as: 'service'},
              {field: "scanned_ports.product || ' ' || (CASE WHEN scanned_ports.product_version IS NULL THEN '' ELSE scanned_ports.product_version END) || ' ' || (CASE WHEN scanned_ports.product_extrainfo IS NULL THEN '' ELSE scanned_ports.product_extrainfo END)", as: 'product'}]
    @datatable = ScannedPort.dt_all(params, fields)
    respond_to do |format|
      format.json {render 'datatable'}
    end
  end

  def new_services
    authorize :dashboard
    @user_active_services = current_user.jobs_active_services
  end

  def hosts
    authorize :dashboard
    #@organizations = policy_scope(Organization)
    @hosts = current_user.hosts
  end

end
