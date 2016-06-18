FactoryGirl.define do
  factory :service do
    name "Deneb service"
    transient do
      organization_name 'Deneb inc.'
    end
    before(:create) do |service, evaluator|
      organization = Organization.where(name: evaluator.organization_name).first || FactoryGirl.create(:organization, name: evaluator.organization_name)
      service.organization_id = organization.id
    end
    legality 1
    host "192.168.1.1"
    port ""
    protocol nil
    description "MyText"
  end
end
