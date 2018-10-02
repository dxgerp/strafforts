class RemoveFromMailingListJob < ApplicationJob
  queue_as :default

  def perform(athlete_id, athlete_email)
    ::MailChimpApiWrapper.new.remove_from_list(athlete_id, athlete_email) unless ENV['MAILCHIMP_API_KEY'].blank?
    ::MailerLiteApiWrapper.new.remove_from_group(athlete_id, athlete_email) unless ENV['MAILER_LITE_API_KEY'].blank?
  end
end
