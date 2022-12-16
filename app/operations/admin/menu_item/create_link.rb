module Operations::Admin::MenuItem
  class CreateLink < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :menu_link_item do
        str? :title
        str? :sort, format: :integer
        str? :page_attr
        str? :external_link
        str? :parent_id
        str? :use_namespace_for_active_detection, format: :boolean
      end
    end

    model ::MenuLinkItem

    def perform
      given_page = osparams.menu_link_item[:page_attr]
      if ::MenuItem::PREDEFINED_PAGES.key?(given_page)
        model.static_page_name = given_page
      elsif given_page.present?
        model.page_id = given_page.to_i
      end

      super
    end

    def page_candidates
      candidates = {}
      predefined_pages = []
      content_pages = []

      # Add "static" pages
      ::MenuItem::PREDEFINED_PAGES.each do |page|
        predefined_pages << [page[1][:title], page[0]]
      end

      # Add dynamic pages
      ::ContentPage.order(:title).each do |page|
        content_pages << [page.title, page.id]
      end

      candidates[_('MenuItem|Predefined pages')] = predefined_pages
      candidates[_('MenuItem|Content pages')] = content_pages

      candidates
    end

    def parent_candidates
      ::MenuDropdownItem.order(:title)
    end
  end
end
