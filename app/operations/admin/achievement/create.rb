module Operations::Admin::Achievement
  class Create < RailsOps::Operation::Model::Create
    schema3 do
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
