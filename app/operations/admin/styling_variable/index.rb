module Operations::Admin::StylingVariable
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_styling_variables, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, StylingVariable
    end

    def grid
      @grid ||= Grids::Admin::StylingVariables.new(osparams.grids_admin_styling_variables) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
