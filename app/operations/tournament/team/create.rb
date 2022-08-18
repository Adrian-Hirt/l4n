module Operations::Tournament::Team
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      str? :name
    end

    model ::Tournament::Team

    def perform
      model.tournament = tournament
      model.status = 'created'
      super
    end

    private

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end
end
