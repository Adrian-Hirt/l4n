class HomeController < ApplicationController
  before_action :enable_sidebar_layout

  def index
    op Operations::Homepage::Index
  end
end
