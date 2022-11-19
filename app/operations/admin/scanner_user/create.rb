module Operations::Admin::ScannerUser
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :scanner_user do
        str? :name
        str? :password
        str? :lan_party_id
      end
    end

    model ::ScannerUser
  end
end
