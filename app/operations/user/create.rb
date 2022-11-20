module Operations::User
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :user do
        str! :username
        str! :email
        str! :password
      end
      str? :'g-recaptcha-response'
      str? :'h-captcha-response'
    end

    policy :on_init do
      fail SignupClosed unless FeatureFlag.enabled?(:user_registration)
    end

    without_authorization

    model ::User
  end

  class SignupClosed < StandardError; end
end
