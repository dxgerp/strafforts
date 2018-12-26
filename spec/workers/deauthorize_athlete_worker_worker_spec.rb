require 'rails_helper'

RSpec.describe DeauthorizeAthleteWorkerWorker, type: :worker do
  it 'should enqueue the job' do
    DeauthorizeAthleteWorkerWorker.perform_async
    expect(DeauthorizeAthleteWorkerWorker).to have_enqueued_sidekiq_job
    expect(DeauthorizeAthleteWorkerWorker).to save_backtrace
    expect(DeauthorizeAthleteWorkerWorker).to be_retryable 0
  end
end
