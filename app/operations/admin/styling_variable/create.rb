module Operations::Admin::StylingVariable
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :styling_variable do
        str? :key
        str? :light_mode_value
        str? :dark_mode_value
      end
    end

    model ::StylingVariable

    def perform
      super
      Rails.cache.delete('l4n/styling-variables')
    end

    def key_candidates
      @key_candidates ||= ::StylingVariable::AVAILABLE_KEYS - ::StylingVariable.pluck(:key)
    end
  end
end
