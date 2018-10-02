# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # DEPRECATED. This is now handled by Mailer Lite workflow.
  def welcome_email
    athlete = Athlete.find_by(id: 9123806)
    UserMailer.welcome_email(athlete)
  end
end
