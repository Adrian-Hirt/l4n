module Operations::Admin::MenuItem
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :menu_link_item do
        str! :title_en
        str! :title_de
        str! :sort, format: :integer
        str? :page_name
        str? :parent_id
      end
      hsh? :menu_dropdown_item do
        str! :title_en
        str! :title_de
        str! :sort, format: :integer
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
