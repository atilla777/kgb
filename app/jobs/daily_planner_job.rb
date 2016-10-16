class DailyPlannerJob < ActiveJob::Base
  queue_as :planner

  def perform(*args)
    today_jobs = Job.today_jobs # Список работ на сегодня
    today_jobs.each do |job|
      ScanJob.perform_later(job.id) # Постановка работы в очередь на выполнение
    end

    # После планирования работ на сегодняшний день, перезапустить планировщик работ завтра
    if Rails.env.production?
      DailyPlannerJob.set(wait_until: Date.tomorrow.midnight).perform_later # запускать раз в день (рабочий режим)
    else
      DailyPlannerJob.set(wait: 10.minutes).perform_later # запускать чаще чем раз в сутки (для отладки)
    end
  end

end
