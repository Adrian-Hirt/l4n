module Operations::Admin::ScannerUser
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :scanner_user do
        str? :name
        str? :password
      end
    end

    model ::ScannerUser
  end
end
