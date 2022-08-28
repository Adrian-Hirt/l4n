module Operations::Admin::Tournament::Team
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      hsh? :tournament_team do
        str? :name
      end
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
end
