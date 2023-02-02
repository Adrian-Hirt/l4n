module Operations::Admin::Tournament
  class ToggleRegistration < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament

    policy do
      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot toggle
      # the registration.
      fail TournamentHasOngoingPhases if model.ongoing_phases?
    end

    def perform
      model.toggle(:registration_open)
      model.save!
    end
  end

  class TournamentHasOngoingPhases < StandardError; end
end
