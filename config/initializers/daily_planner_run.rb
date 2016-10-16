Rails.application.config.after_initialize do
  if ActiveRecord::Base.connection.table_exists? 'delayed_jobs'
  # добавить проверку того, что планировщик сегодня не запускался
    #Delayed::Job.destroy_all # удаляем все задачи (задачу планировщика на завтра и запланированные им работы по сканированию на сегодня )
  #
    planner = Delayed::Job.where(queue: 'planner').first
    if planner.blank?
      DailyPlannerJob.perform_later # запускаем планировщик работ по сканированию (в свою очередь он запланирует все работы на сегодня)
    end
  end
end
