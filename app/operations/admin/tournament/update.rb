module Operations::Admin::Tournament
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament do
        str? :name
        obj? :team_size
        obj? :max_number_of_participants
        obj? :singleplayer
        obj? :status
        obj? :files
        obj? :remove_files
        obj? :lan_party_id
        obj? :description
      end
    end

    model ::Tournament do
      attribute :remove_files
    end

    def perform
      model.team_size = 1 if model.singleplayer?

      super

      osparams.tournament[:remove_files]&.each do |id_to_remove|
        model.files.find(id_to_remove).purge
      end
    end
  end
end
