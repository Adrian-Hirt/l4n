module Operations::Admin::LanParty
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::LanParty
  end
end
