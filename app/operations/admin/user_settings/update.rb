module Operations::Admin::UserSettings
  class Update < RailsOps::Operation::Model::Update
    schema do
      opt :user do
        opt :admin_panel_dark_mode
        opt :admin_panel_sidebar_dark_mode
        opt :admin_sidebar_highlight_color
      end
    end

    model ::User

    private

    def build_model
      @model = context.user
      build_nested_model_ops :update
      assign_attributes
    end
  end
end
