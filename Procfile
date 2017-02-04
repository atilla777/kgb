web: authbind --deep bundle exec puma
planner_worker: QUEUE=planner bundle exec rake jobs:work
now_scan_worker: QUEUE=now_scan bundle exec rake jobs:work
planned_scan_worker: QUEUE=planned_scan bundle exec rake jobs:work
