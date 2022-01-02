module Operations::Admin::MenuItem
  class CreateDropdown < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :menu_dropdown_item do
        str! :title_en
        str! :title_de
        str! :sort, format: :integer
        str? :visible, format: :boolean
      end
    end

    model ::MenuDropdownItem
  end
end
