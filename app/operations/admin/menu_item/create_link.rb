module Operations::Admin::MenuItem
  class CreateLink < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :menu_link_item do
        str! :title_en
        str! :title_de
        str! :sort, format: :integer
        str? :page_name
        str? :parent_id
      end
    end

    model ::MenuLinkItem

    def page_candidates
      candidates = []

      # Add "static" pages
      ::MenuItem::PREDEFINED_PAGES.each do |page|
        candidates << [page[1][:title], page[0]]
      end

      # Add dynamic pages
      ::Page.order(:title).each do |page|
        candidates << [page.title, page.url]
      end

      candidates
    end

    def parent_candidates
      ::MenuDropdownItem.i18n.order(:title)
    end
  end
end
