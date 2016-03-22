class ScanJob < ActiveJob::Base

  require 'nmap/program'
  require 'nmap/xml'

  queue_as :default

  def perform(*args)
    job_id = args[0]
    job = Job.find(job_id)
    # имя работы
    job_time = DateTime.now
    # путь к папке с результатами сканирования (относительно папки rails приложения)
    result_folder = "tmp"
    # имя файла с результатами сканирования
    result_file = "#{job_id}_#{job_time.strftime("%Y.%m.%d-%H.%M.%S")}_nmap.xml"
    # полный путь к файлу с результатами сканирования (относительно папки rails приложения)
    result_path = "#{result_folder}/#{result_file}"

    # сканирование
    #
    scan_options = job.option_set.options.select {|key, value| value == '1'}
    scan_options.update(scan_options) {|key, value| value = true if value == '1'}
    scan_options[:xml] = result_path
    scan_options[:targets] = job.hosts
    scan_options[:ports] = job.ports.split(', ')
    scan_options[:ports] = scan_options[:ports].map do |port|
      if port.include?('-')
        Range.new(port.split("-").map(&:to_i))
      else
        port.to_i
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
                 product: port.service.product,
                 product_version: port.service.version,
                 product_extrainfo: port.service.extra_info,
                 service: port.service)
          scanned_port.save
        end
      end
    end
    File.delete(result_path)

  end

end
