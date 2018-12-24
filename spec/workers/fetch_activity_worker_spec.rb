require 'rails_helper'

RSpec.describe FetchActivityWorker, type: :worker do
  it 'should enqueue the job' do
    ACCESS_TOKEN = '3f2a45886980ebec9f4a689371e95860'.freeze

    FetchActivityWorker.perform_async('3f2a45886980ebec9f4a689371e95860')
    expect(FetchActivityWorker).to have_enqueued_sidekiq_job('3f2a45886980ebec9f4a689371e95860')
    expect(FetchActivityWorker).to be_retryable 0
  end
end
