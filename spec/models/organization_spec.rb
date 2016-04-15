require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe '#detected_services' do

    before(:all) do
      FactoryGirl.create(:user)
      FactoryGirl.create(:service)
    end

    let(:organization) {organization = Organization.where(name: 'Deneb inc.').first}
    let(:user) {current_user = User.where(name: 'Aleksey').first}

    context 'when job owned by organization has runned ine time, scan detect open ports' do
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
      it 'show in dashboard only 6 open ports' do
        detected_services = organization.detected_services(user).all
        expect(detected_services.length).to eq(7)
      end
    end

    context 'when job owned by organization has complited several times, ports change thier states' do
      before(:context) do
        FactoryGirl.create(:scanned_port, last_job: true, port: 11, state: 'open|filtered')
        FactoryGirl.create(:scanned_port, last_job: true, port: 21, state: 'open')
        FactoryGirl.create(:scanned_port, last_job: true, port: 111, state: 'closed')
        FactoryGirl.create(:scanned_port, last_job: true, port: 443, state: 'open')
      end
      it 'show in dashboard only 3 actual open ports' do
        detected_services = organization.detected_services(user).all
        expect(detected_services.length).to eq(3)
      end
    end

  end

end
