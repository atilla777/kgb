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
    result_file = "#{job_id}_#{job_time.strftime("%Y.%m.%d-%H.%m.%s")}_nmap.xml"
    # полный путь к файлу с результатами сканирования (относительно папки rails приложения)
    result_path = "#{result_folder}/#{result_file}"

    # сканирование
    Nmap::Program.sudo_scan do |nmap|

      # опции сканирования
      nmap.syn_scan = true
      nmap.service_scan = true
      nmap.os_fingerprint = true
      nmap.xml = result_path
      nmap.verbose = true
      nmap.ports = job.ports
      nmap.targets = job.hosts

    end

    # сохранить result_file_name в таблицу выполненных сканирований

    # обработка результатов сканирования (парсинг xml файла)
    Nmap::XML.new(result_path) do |xml|
      xml.each_host do |host|
        #puts "[#{host.ip}]"

        host.each_port do |port|
          #puts "  #{port.number}/#{port.protocol}\t#{port.state}\t#{port.service}"
          # сохранение результата в базе§

          legality = Service.legality_key(port.state, host.ip, port.number, port.protocol)

          scanned_port = ScannedPort.new(job_time: job_time,
                 job_id: job.id,
                 organization_id: job.organization_id,
                 #host_id: host.ip,
                 host_ip: host.ip,
                 #port_id:,
                 number: port.number,
                 protocol: port.protocol,
                 state: port.state,
                 legality: legality,
                 service: port.service)
          scanned_port.save
        end
      end
    end

  end

end
