module Operations::Admin::Promotion
  class AddCodes < RailsOps::Operation::Model::Update
    schema3 do
      str! :id
      hsh? :promotion do
        int? :additional_codes_to_generate, cast_str: true
      end
    end

    model ::Promotion do
      attribute :additional_codes_to_generate, :integer
      validates :additional_codes_to_generate, presence: true, numericality: { min: 0 }
    end

    def perform
      fail RailsOps::Exceptions::ValidationFailed unless model.valid?

      model.additional_codes_to_generate.to_i.times do
        model.promotion_codes.create!(
          code: create_token
        )
      end
    end

    private

    def create_token
      # If the prefix is present, we only generate a "short"
      # code, else we generate a slightly longer code
      if model.code_prefix.present?
        loop do
          token = SecureRandom.alphanumeric(15).downcase.scan(/.{1,5}/).join('-')
          code = "#{model.code_prefix}-#{token}"
          break code unless PromotionCode.where(code: code).any?
        end
      else
        loop do
          code = SecureRandom.alphanumeric(20).downcase.scan(/.{1,5}/).join('-')
          break code unless PromotionCode.where(code: code).any?
        end
      end
    end
  end
end
