class NewsController < ApplicationController
  before_action :enable_sidebar_layout

  add_breadcrumb _('News'), :news_index_path

  def index
    op Operations::NewsPost::Index
  end

  def show
    op Operations::NewsPost::Load
    add_breadcrumb model.title
  end
end
