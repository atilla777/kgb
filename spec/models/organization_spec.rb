require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe '#detected_services' do

    before(:all) do
      DatabaseCleaner.clean_with :truncation
      FactoryGirl.create(:user)
      FactoryGirl.create(:service)
    end

    let(:organization) {Organization.where(name: 'Deneb inc.').first}
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
      end
      xit 'show in dashboard only 6 open ports' do
        detected_services = organization.detected_services(user).all
        expect(detected_services.length).to eq(7)
      end
    end

    context 'when job (owned by organization) has complited several times, ports change thier states' do
      before(:context) do
        FactoryGirl.create(:scanned_port, last_job: true, port: 11, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, last_job: true, port: 21, state: 'open')
        FactoryGirl.create(:scanned_port, last_job: true, port: 111, state: 'closed')
        FactoryGirl.create(:scanned_port, last_job: true, port: 443, state: 'open')
      end
      xit 'show in dashboard only 3 actual open ports' do
        detected_services = organization.detected_services(user).all
        expect(detected_services.length).to eq(3)
      end
      xit 'include port 11 with open|filtered state finded on last scan job' do
        detected_services = organization.detected_services(user).all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 11,
                                    state: 'open|filtered',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(detected_services).to include(scanned_port)
      end
      xit 'include port 21 with open state finded on last scan job' do
        detected_services = organization.detected_services(user).all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 21,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(detected_services).to include(scanned_port)
      end
      xit 'include port 443 with open state finded on last scan job' do
        detected_services = organization.detected_services(user).all
        scanned_port = ScannedPort.where(host: '192.168.1.1',
                                    protocol: 'tcp',
                                    port: 443,
                                    state: 'open',
                                    job_id: Job.where(name: 'Check Deneb').first,
                                    organization_id: Organization.where(name: 'Deneb inc.').first,
                                    job_time: '2016-04-04 12:12:12'.to_time).first # 12 - 3 MSK
        expect(detected_services).to include(scanned_port)
      end
    end

  end

end
