module Operations::Admin::MenuItem
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id, format: :integer
    end

    model ::MenuItem
  end
end
