Rails.application.config.after_initialize do
    # добавить проверку того, что планировщик сегодня не запускался
    DailyPlannerJob.perform_later
end
