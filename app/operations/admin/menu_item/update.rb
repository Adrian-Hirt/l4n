module Operations::Admin::MenuItem
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :menu_item do
        str! :title_en
        str! :title_de
        str? :page_name
        str! :sort, format: :integer
        str! :visible, format: :boolean
        str? :parent_id
      end
    end

    model ::MenuItem

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
      ::MenuItem.i18n.where(parent: nil).where.not(id: model.id).order(:title)
    end
  end
end
