module FormattingHelper
  def format_boolean(value)
    if value
      icon %i[fas fa-check-square]
    else
      icon %i[far fa-square]
    end
  end
end
