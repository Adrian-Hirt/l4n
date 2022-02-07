module Operations::UserAddress
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :user_address do
        str! :first_name
        str! :last_name
        str! :street
        str! :zip_code
        str! :city
      end
    end

    model ::UserAddress

    def perform
      model.user = context.user
      super
    end
  end
end
