namespace :subscriptions do
  desc 'Automatically renew due subscriptions.'
  # Usage: bundle exec bin/rails subscriptions:renew
  task renew: :environment do
    task_runner = TaskRunner.new
    task_runner.delay(priority: 5).renew_subscriptions
  end
end
