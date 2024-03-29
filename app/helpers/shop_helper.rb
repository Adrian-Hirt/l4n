module ShopHelper
  def current_cart
    @current_cart ||= Cart.find_or_create_by(user: current_user)
  end

  def seat_category_badge(seat_category)
    tag.div(class: 'badge', style: "background-color: #{seat_category.color_for_view}; color: #{seat_category.font_color_for_view};") do
      seat_category.name
    end
  end

  def ticket_seat_category_badge(ticket)
    seat_category_badge(ticket.seat_category)
  end

  def money_formatted(money)
    if (money.cents % 100).zero?
      "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'', no_cents_if_whole: true)}.- CHF"
    else
      "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'')} CHF"
    end
  end
end
