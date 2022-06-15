module Operations::Admin::PromotionCode
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id
    end

    model ::PromotionCode
  end
end
