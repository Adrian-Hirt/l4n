module DummyPayment
  class ApplicationController < ActionController::Base
    private

    def current_user
      nil
    end
  end
end