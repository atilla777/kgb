module DjManagerHelper
  def planner_stopped?
    Delayed::Job.where(queue: 'planner').first.blank?
  end
end
