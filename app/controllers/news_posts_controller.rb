class NewsPostsController < ApplicationController
  def index
    op Operations::NewsPost::Index
  end

  def show
    op Operations::NewsPost::Load
  end
end
