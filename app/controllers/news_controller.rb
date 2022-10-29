class NewsController < ApplicationController
  before_action :enable_sidebar_layout

  def index
    op Operations::NewsPost::Index, page: params[:page]
  end

  def show
    op Operations::NewsPost::Load
  end
end
