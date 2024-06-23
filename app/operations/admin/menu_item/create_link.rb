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
        str? :lan_party_id
      end
    end

    model ::MenuLinkItem

    def perform
      given_page = osparams.menu_link_item[:page_attr]
      if ::MenuLinkItem::PREDEFINED_PAGES.key?(given_page) || ::MenuLinkItem::PREDEFINED_LAN_PAGES.key?(given_page)
        model.static_page_name = given_page
      elsif given_page.present?
        model.page_id = given_page.to_i
      end

      super
    end

    def page_candidates
      candidates = {}
      # Add "static" pages
      predefined_pages = ::MenuLinkItem::PREDEFINED_PAGES.map do |page|
        [page[1][:title], page[0]]
      end

      # Add "static" lan party pages
      predefined_lan_pages = ::MenuLinkItem::PREDEFINED_LAN_PAGES.map do |page|
        [page[1][:title], page[0]]
      end

      # Add dynamic pages
      content_pages = ::ContentPage.order(:title).map do |page|
        [page.title, page.id]
      end

      candidates[_('MenuItem|Predefined pages')] = predefined_pages
      candidates[_('MenuItem|Predefined lan pages')] = predefined_lan_pages
      candidates[_('MenuItem|Content pages')] = content_pages

      candidates
    end

    def parent_candidates
      ::MenuDropdownItem.order(:title)
    end
  end
end
