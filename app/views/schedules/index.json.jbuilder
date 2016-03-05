json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :job_id, :week_day, :month_day
  json.url schedule_url(schedule, format: :json)
end
