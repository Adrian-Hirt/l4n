module HeaderExtension
  def header
    return nil if options[:header] == false

    if grid_class.model.present? && options[:header].blank?
      _("#{grid_class.model}|#{name.to_s.humanize}")
    else
      super
    end
  end
end

class Datagrid::Columns::Column
  prepend ::HeaderExtension
end
