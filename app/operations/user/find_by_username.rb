module Operations::User
  class FindByUsername < RailsOps::Operation
    schema3 do
      str! :username
    end

    attr_accessor :result

    # No special auth needed
    without_authorization

    def perform
      user = ::User.find_by('LOWER(username) = ?', osparams.username.downcase)

      fail RailsOps::Exceptions::ValidationFailed if user.nil?

      @result = { username: user.username, id: user.id }
    end
  end
end
