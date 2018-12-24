class FetchActivityWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(access_token, options = {})
    fetcher = ::ActivityFetcher.new(access_token)
    fetcher.fetch_all(options)
  end
end
