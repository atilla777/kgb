class ScanJob < ActiveJob::Base

  require 'nmap/program'
  require 'nmap/xml'

  queue_as do #:default
    arg = self.arguments.second
    if arg == 'now'
      :now_scan
    else
      :planned_scan
    end
  end

  def perform(*args)
    job = args[0]
    # имя работы
    job_time = DateTime.now
    result_path = set_result_path(job, job_time)

    # сканирование
    #
    scan_options = job.option_set.options.select {|key, value| value != '0'}
    scan_options.update(scan_options) {|key, value| value = true if value == '1'}
    scan_options[:xml] = result_path
    scan_options[:targets] = job.hosts
    if job.ports.present?
      scan_options[:ports] = job.ports.split(',')
      scan_options[:ports] = scan_options[:ports].map do |port|
        if port.include?('-')
          Range.new(*port.split("-").map(&:to_i))
        else
          port.to_i
        end
      end
    end
    scan_options[:verbose] = true

    #byebug
    Nmap::Program.sudo_scan(scan_options)

    # сохранить result_file_name в таблицу выполненных сканирований
    # обработка результатов сканирования (парсинг xml файла)
    Nmap::XML.new(result_path) do |xml|
      xml.each_host do |host|
        #puts "[#{host.ip}]"
        if host.ports.present?
          host.each_port do |port|
            #puts "  #{port.number}/#{port.protocol}\t#{port.state}\t#{port.service}"
            # сохранение результата в базе
            legality = Service.legality_key(port.state, host.ip, port.number, port.protocol)
            scanned_port = ScannedPort.new(job_time: job_time,
                                           job_id: job.id,
                                           organization_id: job.organization_id,
                                           #host_id: host.ip,
                                           host: host.ip,
                                           #port_id:,
                                           port: port.number,
                                           protocol: port.protocol,
                                           state: port.state,
                                           legality: legality,
                                           product: port&.service&.product,
                                           product_version: port&.service&.version,
                                           product_extrainfo: port&.service&.extra_info,
                                           service: port.service)
            scanned_port.save
          end
        else
          scanned_port = ScannedPort.new(job_time: job_time,
                                         job_id: job.id,
                                         organization_id: job.organization_id,
                                         host: host.ip,
                                         port: 0,
                                         protocol: '',
                                         state: 'closed',
                                         legality: 3,
                                         product: '',
                                         product_version: '',
                                         product_extrainfo: '',
                                         service: '')
          scanned_port.save
        end
      end
    end
    File.delete(result_path)
  end

  private
  def set_result_path(job, job_time)
    # путь к папке с результатами сканирования (относительно папки rails приложения)
    result_folder = "tmp"
    # имя файла с результатами сканирования
    result_file = "#{job.id}_#{job_time.strftime("%Y.%m.%d-%H.%M.%S")}_nmap.xml"
    # полный путь к файлу с результатами сканирования (относительно папки rails приложения)
    "#{result_folder}/#{result_file}"
  end

end
