module Operations::Admin::User
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, User
    end

    def grid
      @grid ||= Grids::Admin::Users.new(osparams.grids_users) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
