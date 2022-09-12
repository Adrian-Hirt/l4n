module Operations::Admin::Tournament
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :tournament do
        str? :name
        obj? :team_size
        obj? :max_number_of_participants
        obj? :singleplayer
        obj? :status
        obj? :files
        obj? :lan_party_id
        obj? :frontend_order
        obj? :description
      end
    end

    model ::Tournament

    def perform
      model.team_size = 1 if model.singleplayer?

      super
    end
  end
end
