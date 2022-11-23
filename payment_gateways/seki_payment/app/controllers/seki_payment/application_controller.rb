module SekiPayment
  class ApplicationController < ActionController::Base
    def self.money_formatted(money)
      if (money.cents % 100).zero?
        "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'', no_cents_if_whole: true)}.- CHF"
      else
        "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'')} CHF"
      end
    end

    private

    def current_user
      nil
    end
  end
end
