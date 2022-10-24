module Operations::User
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_users, additional_properties: true
    end

    # No special auth needed
    without_authorization

    def grid
      @grid ||= Grids::Users.new(osparams.grids_users) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
