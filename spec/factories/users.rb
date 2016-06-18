FactoryGirl.define do
  factory :user do
    name "Aleksey"
    phone "MyString"
    job "MyString"
    description "MyText"
    transient do
      organization_name 'Deneb inc.'
    end
    before(:create) do |user, evaluator|
      organization = Organization.where(name: evaluator.organization_name).first || FactoryGirl.create(:organization, name: evaluator.organization_name)
      user.organization_id = organization.id
    end
    transient do
      organization_editor true
    end
    after(:create) do |user, evaluator|
      user.add_role(:editor)
      user.add_role(Organization.beholder_role_name, user.organization) if evaluator.organization_editor
    end
    department "MyString"
  end
end
