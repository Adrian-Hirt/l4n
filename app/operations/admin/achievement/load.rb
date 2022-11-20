module Operations::Admin::Achievement
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      str? :page
      hsh? :grids_admin_user_achievements, additional_properties: true
    end

    model ::Achievement

    def grid
      grid_params = osparams.grids_admin_user_achievements || {}
      grid_params[:achievement] = model

      @grid ||= Grids::Admin::UserAchievements.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
