class NewsPostsController < ApplicationController
  def index
    op Operations::NewsPost::Index, page: params[:page]
  end

  def show
    op Operations::NewsPost::Load
  end
end
