module Operations::User
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_users, additional_properties: true
    end

    policy :on_init do
      authorize! :read, ::User
    end

    def grid
      @grid ||= Grids::Users.new(osparams.grids_users) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
