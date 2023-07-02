module Operations::Admin::StylingVariable
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :styling_variable do
        str? :light_mode_value
        str? :dark_mode_value
      end
    end

    model ::StylingVariable

    def perform
      super
      Rails.cache.delete('l4n/styling-variables')
    end
  end
end
