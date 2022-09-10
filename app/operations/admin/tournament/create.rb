module Operations::Admin::Tournament
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :tournament do
        str? :name
        obj? :team_size
        obj? :max_number_of_participants
        obj? :singleplayer
      end
    end

    model ::Tournament
  end
end
