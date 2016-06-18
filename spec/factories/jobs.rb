FactoryGirl.define do
  factory :job do
    name "Check Deneb"
    description "MyText"
    ports "1-1000"
    hosts "192.168.1.1"
    organization_id 1
    option_set_id 1
  end
end
