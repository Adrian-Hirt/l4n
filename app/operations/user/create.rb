module Operations::User
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :user do
        str! :username
        str! :email
        str! :password
        str! :password_confirmation
      end
      str? :'g-recaptcha-response'
    end

    without_authorization

    model ::User

    def perform
      model.activation_token = SecureRandom.urlsafe_base64(32)
      super

      UserMailer.with(user: model).confirm_signup.deliver_now
    end
  end
end
