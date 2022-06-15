module Operations::Admin::Promotion
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :promotion do
        str! :name
        boo! :active, cast_str: true
        str! :code_type
        str? :reduction
        str? :code_prefix
        ary? :product_ids
        int? :codes_to_generate, cast_str: true
      end
    end

    model ::Promotion do
      attribute :codes_to_generate

      validates :codes_to_generate, presence: true, numericality: { min: 0 }
    end

    def perform
      super

      model.codes_to_generate.to_i.times do
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
