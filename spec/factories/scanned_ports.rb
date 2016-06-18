FactoryGirl.define do
  factory :scanned_port do
    transient do
      organization_name 'Deneb inc.'
    end
    before(:create) do |scanned_port, evaluator|
      organization = Organization.where(name: evaluator.organization_name).first || FactoryGirl.create(:organization, name: evaluator.organization_name)
      scanned_port.organization_id = organization.id
    end
    transient do
      job_name 'Check Deneb'
    end
    before(:create) do |scanned_port, evaluator|
      job = Job.where(name: evaluator.job_name).first || FactoryGirl.create(:job, name: evaluator.job_name)
      scanned_port.job_id = job.id
    end
    transient do
      last_job false
    end
    job_time do
      last_job ? '2016-04-04 12:12:12' : '2016-01-01 11:11:11'
    end
    host "192.168.1.1"
    port 21
    protocol "tcp"
    state "open"
    service "ftp"
    legality 1
  end
end
