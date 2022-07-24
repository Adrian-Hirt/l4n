require 'csv'

module Operations::Admin::Promotion
  class ExportCodes < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
    end

    model ::Promotion

    attr_accessor :data

    def perform
      @data = CSV.generate do |csv|
        csv << %w[Code Used]

        model.promotion_codes.each do |promotion_code|
          csv << [promotion_code.code, promotion_code.order.present?]
        end
      end
    end
  end
end
