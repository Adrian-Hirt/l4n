module Operations::Admin::Tournament
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament do
        str? :name
        obj? :team_size
      end
    end

    model ::Tournament
  end
end
