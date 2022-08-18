module Operations::Admin::Tournament::Phase
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int? :tournament_id
      hsh? :tournament_phase do
        str? :name
        str? :tournament_mode
      end
    end

    model ::Tournament::Phase

    def perform
      model.tournament = tournament
      max_phase_number = tournament.phases.maximum(:phase_number) || 0
      model.phase_number = max_phase_number + 1
      super
    end

    private

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end
end
