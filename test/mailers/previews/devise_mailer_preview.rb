require_relative '../../test_data_factory'

class DeviseMailerPreview < ActionMailer::Preview
  include ::TestDataFactory

  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(::User.first, Devise.friendly_token)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(::User.first, Devise.friendly_token)
  end
end
