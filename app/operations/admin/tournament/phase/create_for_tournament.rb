module Operations::Admin::Tournament::Phase
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int? :tournament_id, cast_str: true
      hsh? :tournament_phase do
        str? :name
        str? :tournament_mode
        int? :size, cast_str: true
      end
    end

    model ::Tournament::Phase

    def perform
      max_phase_number = tournament.phases.maximum(:phase_number) || 0
      model.phase_number = max_phase_number + 1
      super
    end

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end

    def build_model
      super
      model.tournament = tournament
    end
  end
end
