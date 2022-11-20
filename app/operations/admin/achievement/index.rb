module Operations::Admin::Achievement
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_achievements, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, Achievement
    end

    def grid
      @grid ||= Grids::Admin::Achievements.new(osparams.grids_admin_achievements) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
