module Operations::Admin::Tournament::Team
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament_team do
        str? :name
        str? :password
        str? :tournament_team_rank_id
      end
    end

    model ::Tournament::Team

    def ranks
      @ranks ||= model.tournament.tournament_team_ranks.order(:sort)
    end
  end
end
