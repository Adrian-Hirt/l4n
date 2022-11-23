module DummyPayment
  class ApplicationController < ActionController::Base
    private

    def current_user
      nil
    end

    def self.money_formatted(money)
      if (money.cents % 100).zero?
        "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'', no_cents_if_whole: true)}.- CHF"
      else
        "#{money.format(symbol: false, decimal_mark: '.', thousands_separator: '\'')} CHF"
      end
    end
  end
end
