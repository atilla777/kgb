require 'rails_helper'

RSpec.describe Job, type: :model do
    before(:all) do
    require 'database_cleaner'
    DatabaseCleaner.clean_with :truncation
  end

  context "create new" do
    it "valid when host is www.hrundel.ru" do
      expect(FactoryGirl.build(:job, hosts: 'www.hrundel.ru')).to have(0).errors.on(:hosts)
    end
    it "invalid when host is www./hrundel.ru" do
      expect(FactoryGirl.build(:job, hosts: 'www.hrundel.ru')).to have(1).errors.on(:hosts)
    end
  end
end
