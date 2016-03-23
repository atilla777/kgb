namespace :import do
  desc 'Import organizations an thier IPs from csv - id,id,orhanization,ip'
  task organizations: :environment do

    File.open("db/organizations_hosts.csv", 'r') do |file|
      rows = file.readlines
      rows.map! {|row| row.chomp.split(';')}
      rows.each do |row|
        organization = Organization.find_or_create_by!(name: row[1]) do
          puts "Import organization - #{row[1]} - OK!"
        end
        unless row[0].blank?
          Service.find_or_create_by!(host: row[0], organization_id: organization.id) do |service|
            service.name = "#{I18n.t('activerecord.attributes.service.host')} #{organization.name}"
            puts "Import host - #{row[0]} - OK!"
          end
        end
      end
    end

  end
end
