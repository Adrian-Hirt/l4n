module Operations::Admin::StylingVariable
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::StylingVariable

    def perform
      super
      Rails.cache.delete('l4n/styling-variables')
    end
  end
end
