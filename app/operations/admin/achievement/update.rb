module Operations::Admin::Achievement
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :achievement do
        str? :title
        str? :description
        obj? :icon
        str? :lan_party_id
      end
    end

    model ::Achievement
  end
end
