module Grids
  class ApplicationGrid
    include Datagrid

    def self.model(model_class = nil)
      return @model unless model_class

      @model = model_class
    end

    def self.pagination_param(pagination_param_name = nil)
      return @pagination_param unless pagination_param_name

      @pagination_param = pagination_param_name
    end

    def self.humanize_enum_for_select(klass, enum_name, enum_entry)
      _("#{klass.name}|#{enum_name}|#{enum_entry}")
    end
  end
end
