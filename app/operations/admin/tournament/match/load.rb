module Operations::Admin::Tournament::Match
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Match
  end
end
