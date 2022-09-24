module Operations::Admin::ScannerUser
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::ScannerUser
  end
end
