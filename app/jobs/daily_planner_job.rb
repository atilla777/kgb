class DailyPlannerJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    today_jobs = Job.today_jobs # Список раот на сегодня
    today_jobs.each do |job|
      ScanJob.perform_later(job.id) # Постановка работы в очередь на выполнение
    end

    # После планирования работ на сегодняшний день, перезапустить планировщик работ завтра
    DailyPlannerJob.set(wait: 120.minutes).perform_later # запускать чаще чем раз в сутки (для отладки)
    #DailyPlannerJob.set(wait_until: Date.tomorrow.midnight).perform_later # запускать раз в день (рабочий режим)
  end

end
