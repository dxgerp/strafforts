class RemoveFromMailingListJob < ApplicationJob
  queue_as :default

  def perform(athlete_id, athlete_email)
    ::MailerLiteApiWrapper.new.remove_from_group(athlete_id, athlete_email) unless ENV['MAILER_LITE_API_KEY'].blank?
  end
end
