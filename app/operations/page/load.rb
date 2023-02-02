module Operations::Page
  class Load < RailsOps::Operation::Model
    schema3 ignore_obsolete_properties: true do
      str? :page
    end

    model ::Page

    policy :on_init do
      # Check if the page was found
      fail ActiveRecord::RecordNotFound unless FeatureFlag.enabled?(:pages)

      # Check that the user may access the page
      authorize! :read_public, model
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
