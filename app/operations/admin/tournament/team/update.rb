module Operations::Admin::Tournament::Team
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament_team do
        str? :name
      end
    end

    model ::Tournament::Team
  end
end
