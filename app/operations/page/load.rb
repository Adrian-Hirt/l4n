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
        fail ActiveRecord::RecordNotFound if page.nil? || !page.published?

        page
      end
    end
  end
end
