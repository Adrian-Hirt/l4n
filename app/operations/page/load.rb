module Operations::Page
  class Load < RailsOps::Operation::Model
    schema do
      req :page
    end

    model ::Page

    without_authorization

    policy :on_init do
      fail ActiveRecord::RecordNotFound unless FeatureFlag.enabled?(:pages)
    end

    def model
      @model ||= begin
        page = Page.find_by(url: osparams.page)

        # Check that we found something
        fail ActiveRecord::RecordNotFound if page.nil?

        # If it's a content page, it needs to be published, otherwise we fail as well
        fail ActiveRecord::RecordNotFound if page.is_a?(ContentPage) && !page.published?

        page
      end
    end
  end
end
