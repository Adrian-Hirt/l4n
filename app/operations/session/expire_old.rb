module Operations::Session
  class ExpireOld < RailsOps::Operation
    schema3 {} # No params allowed for now

    without_authorization

    def perform
      Session.where('updated_at < ?', Time.zone.now - Session::EXPIRATION_TIME).destroy_all
    end
  end
end
