module Operations::Admin::LanParty
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :lan_party do
        str! :name
      end
    end

    model ::LanParty
  end
end
