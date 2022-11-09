class PagesController < ApplicationController
  def show
    op Operations::Page::Load
    add_breadcrumb model.title

    enable_sidebar_layout if op.model.use_sidebar?
  end
end
