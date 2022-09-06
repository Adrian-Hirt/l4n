module Operations::Admin::Tournament::Match
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Match

    def result_updateable?
      model.round == model.phase.current_round && model.away_team.present?
    end
  end
end
