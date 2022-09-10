module Operations::Admin::Tournament::Team
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      hsh? :tournament_team do
        str? :name
      end
    end

    policy do
      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail TournamentHasOngoingPhases if tournament.ongoing_phases?
    end

    model ::Tournament::Team

    def perform
      model.tournament = tournament
      model.status = Tournament::Team.statuses[:created]
      super
    end

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end

  class TournamentHasOngoingPhases < StandardError; end
end
