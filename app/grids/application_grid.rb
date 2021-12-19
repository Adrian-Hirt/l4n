module Grids
  class ApplicationGrid
    def self.model(model_class = nil)
      return @model unless model_class

      @model = model_class
    end
  end
end
