module Operations::Admin::LanParty
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::LanParty
  end
end
