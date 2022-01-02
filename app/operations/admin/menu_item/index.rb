module Operations::Admin::MenuItem
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, MenuItem
    end

    def top_items
      ::MenuItem.where(parent_id: nil).order(:sort)
    end
  end
end
