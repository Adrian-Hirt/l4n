module Operations::Admin::UserAchievement
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::UserAchievement
  end
end
