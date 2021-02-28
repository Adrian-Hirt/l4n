module Operations::User
  class Activate < RailsOps::Operation::Model
    schema do
      opt :email
      opt :activation_token
    end

    without_authorization

    model ::User

    def perform
      fail InvalidActivationError if model.activated? || (model.activation_token != osparams.activation_token)

      model.activated = true
      model.activation_token = nil
      model.save!
    end

    def build_model
      @model = User.find_by(email: osparams.email)

      fail InvalidActivationError unless @model.present?
    end
  end

  class InvalidActivationError < StandardError; end
end
