require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#jobs_active_services' do

    before(:all) do
require 'database_cleaner'
      DatabaseCleaner.clean_with :truncation
      FactoryGirl.create(:user)
      FactoryGirl.create(:service)
    end

    let(:user) {User.where(name: 'Aleksey').first}

    context 'when job (owned by organization) has runned one time, scan detect open ports' do
      before(:context) do
        FactoryGirl.create(:scanned_port, port: 11, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, port: 14, state: 'filtered')
        FactoryGirl.create(:scanned_port, port: 17, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, port: 21, state: 'open')
        FactoryGirl.create(:scanned_port, port: 111, state: 'open')
        FactoryGirl.create(:scanned_port, port: 3000, state: 'open')
        FactoryGirl.create(:scanned_port, port: 4001, state: 'closed')
        FactoryGirl.create(:scanned_port, port: 5005, state: 'open')

        FactoryGirl.create(:scanned_port,
                           organization_name: 'Zelda',
                           job_name: 'Test zelda',
                           host: '10.1.1.1',
                           port: 80,
                           state: 'open')
      end
      it 'show in dashboard only 4 open ports' do
        detected_services = user.jobs_active_services.all
        expect(detected_services.length).to eq(4)
      end
    end

    context 'when job (owned by organization) has complited several times, ports change thier states' do
      before(:context) do
        FactoryGirl.create(:scanned_port, port: 11, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, port: 14, state: 'filtered')
        FactoryGirl.create(:scanned_port, port: 17, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, port: 21, state: 'open')
        FactoryGirl.create(:scanned_port, port: 111, state: 'open')
        FactoryGirl.create(:scanned_port, port: 3000, state: 'open')
        FactoryGirl.create(:scanned_port, port: 4001, state: 'closed')
        FactoryGirl.create(:scanned_port, port: 5005, state: 'open')

        FactoryGirl.create(:scanned_port, last_job: true, port: 11, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, last_job: true, port: 21, state: 'open')
        FactoryGirl.create(:scanned_port, last_job: true, port: 111, state: 'closed')
        FactoryGirl.create(:scanned_port, last_job: true, port: 443, state: 'open')

        FactoryGirl.create(:scanned_port,
                           organization_name: 'Vega inc.',
                           job_name: 'Vega scan',
                           last_job: true,
                           host: '172.16.1.1',
                           port: 111,
                           state: 'open')
      end
      it 'show in dashboard only 2 actual open ports' do
        detected_services = user.jobs_active_services.all
        expect(detected_services.length).to eq(2)
      end
      it 'have included port 443 with open state finded on last scan job' do
        detected_services = user.jobs_active_services.all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 443,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(detected_services).to include(scanned_port)
      end
      it 'have included port 21 with open state finded on last scan job' do
        detected_services = user.jobs_active_services.all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 21,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(detected_services).to include(scanned_port)
      end
      it 'have not included port 3000 with open state finded on last scan job' do
        detected_services = user.jobs_active_services.all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 3000,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-01-01 11:11:11'.to_time).first # 12 - 3 MSK
        expect(detected_services).not_to include(scanned_port)
      end
      it 'have included port 3000 with open state finded on previous scan job' do
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 3000,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-01-01 11:11:11'.to_time).first # 12 - 3 MSK
        expect(scanned_port).to be
      end
      it 'have included not displayed port 111 with open state finded on last scan job of Vega inc. (not allowed fot user)' do
        scanned_port = ScannedPort.where(host: '172.16.1.1',
                                    protocol: 'tcp',
                                    port: 111,
                                    state: 'open',
                                    job_id: Job.where(name: 'Vega scan').first,
                                    organization_id: Organization.where(name: 'Vega inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(scanned_port).to be
      end
    end

  end
end
