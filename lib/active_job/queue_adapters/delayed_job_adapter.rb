# file: lib/active_job/queue_adapters/delayed_job_adapter.rb
module ActiveJob
  module Core
    # ID optionally provided by adapter
    attr_accessor :provider_job_id
  end

  module QueueAdapters
    class DelayedJobAdapter
      class << self
        def enqueue(job) #:nodoc:
          delayed_job = Delayed::Job.enqueue(JobWrapper.new(job.serialize), queue: job.queue_name)
          job.provider_job_id = delayed_job.id
          delayed_job
        end

        def enqueue_at(job, timestamp) #:nodoc:
          delayed_job = Delayed::Job.enqueue(JobWrapper.new(job.serialize), queue: job.queue_name, run_at: Time.at(timestamp))
          job.provider_job_id = delayed_job.id
          delayed_job
        end
      end
      class JobWrapper #:nodoc:
        attr_accessor :job_data

        def initialize(job_data)
          @job_data = job_data
        end

        def perform
          Base.execute(job_data)
        end
      end
    end
  end
end
