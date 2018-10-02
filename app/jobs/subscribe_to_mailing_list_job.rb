class SubscribeToMailingListJob < ApplicationJob
  queue_as :default

  def perform(athlete)
    ::MailChimpApiWrapper.new.subscribe_to_list(athlete) unless ENV['MAILCHIMP_API_KEY'].blank?
    ::MailerLiteApiWrapper.new.subscribe_to_group(athlete) unless ENV['MAILER_LITE_API_KEY'].blank?
  end
end
