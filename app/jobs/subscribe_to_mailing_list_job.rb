class SubscribeToMailingListJob < ApplicationJob
  queue_as :default

  def perform(athlete)
    ::MailerLiteApiWrapper.new.subscribe_to_group(athlete) unless ENV['MAILER_LITE_API_KEY'].blank?
  end
end
