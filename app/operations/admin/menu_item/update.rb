module Operations::Admin::MenuItem
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :menu_link_item do
        str? :title
        str? :sort, format: :integer
        str? :page_attr
        str? :external_link
        str? :parent_id
        str? :use_namespace_for_active_detection, format: :boolean
        str? :lan_party_id
      end
      hsh? :menu_dropdown_item do
        str? :title
        str? :sort, format: :integer
        str? :visible, format: :boolean
      end
    end

    model ::MenuItem

    # Needed as default find_model does not work with STI
    def find_model
      fail "Param #{model_id_field.inspect} must be given." unless params[model_id_field]

      # Get model class
      relation = MenuItem

      # Express intention to lock if required
      relation = relation.lock if self.class.lock_model_at_build?

      # Fetch (and possibly lock) model
      relation.find_by!(model_id_field => params[model_id_field])
    end

    def perform
      if model.is_a? MenuLinkItem
        given_page = osparams.menu_link_item[:page_attr]
        model.page_id = nil
        model.static_page_name = nil
        if ::MenuLinkItem::PREDEFINED_PAGES.key?(given_page) || ::MenuLinkItem::PREDEFINED_LAN_PAGES.key?(given_page)
          model.static_page_name = given_page
        elsif given_page.present?
          model.page_id = given_page.to_i
        end
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
