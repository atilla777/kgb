class ScanJob < ActiveJob::Base

  require 'nmap/program'
  require 'nmap/xml'

  queue_as :default

  def perform(*args)
    organization_id = args[0]

    # имя работы
    job_time = DateTime.now
    # путь к папке с результатами сканирования (относительно папки rails приложения)
    result_folder = "tmp"
    # имя файла с результатами сканирования
    result_file = "#{job_time.strftime("%Y.%m.%d-%H.%m.%s")}_nmap.xml"
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
      nmap.ports = [20,21,22,23,25,80,110,443,512,522,8080,1080]
      nmap.targets = ['www.ya.ru']


    end

    # сохранить result_file_name в таблицу выполненных сканирований

    # обработка результатов сканирования (парсинг xml файла)
    Nmap::XML.new(result_path) do |xml|
      xml.each_host do |host|
        #puts "[#{host.ip}]"

        host.each_port do |port|
          #puts "  #{port.number}/#{port.protocol}\t#{port.state}\t#{port.service}"
          # сохранение результата в базе§
          scanned_port = ScannedPort.new(job_time: job_time,
                 organization_id: organization_id,
                 #host_id: host.ip,
                 host_ip: host.ip,
                 #port_id:,
                 number: port.number,
                 protocol: port.protocol,
                 state: port.state,
                 service: port.service)
          scanned_port.save
        end
      end
    end

  end

end
