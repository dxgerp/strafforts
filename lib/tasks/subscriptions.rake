namespace :subscriptions do
  desc 'Automatically renew due subscriptions.'
  # Usage: bundle exec bin/rails subscriptions:renew
  task renew: :environment do
    RenewSubscriptionsWorker.perform_async
  end
end
