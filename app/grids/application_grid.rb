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
  end
end
