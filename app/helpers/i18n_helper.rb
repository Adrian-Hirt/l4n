module I18nHelper
  def humanize_enum_for_select(klass, enum_name, enum_entry)
    _("#{klass.name}|#{enum_name}|#{enum_entry}")
  end
end
