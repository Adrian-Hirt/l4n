module Shop
  class ShopController < ApplicationController
    # Base class for all controllers residing in the shop namespace
    # Do not put controller actions in here, but rather inherit from
    # this controller and add seperate controllers for each resource,
    # it's way cleaner that way
    before_action :authenticate_user!
  end
end
