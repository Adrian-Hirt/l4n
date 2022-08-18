module Operations::Admin::Tournament
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :tournament do
        str? :name
        obj? :team_size
      end
    end

    model ::Tournament
  end
end
