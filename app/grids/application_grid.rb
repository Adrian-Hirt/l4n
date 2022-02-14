module Grids
  class ApplicationGrid
    include Datagrid

    def self.model(model_class = nil)
      return @model unless model_class

      @model = model_class
    end
  end
end
