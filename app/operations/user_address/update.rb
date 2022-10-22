module Operations::UserAddress
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :user_address do
        str? :first_name
        str? :last_name
        str? :street
        str? :zip_code
        str? :city
      end
    end

    model ::UserAddress
  end
end
