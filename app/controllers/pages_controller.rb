class PagesController < ApplicationController
  def show
    op Operations::Page::Load
  end
end
