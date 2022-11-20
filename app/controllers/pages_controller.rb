class PagesController < ApplicationController
  def show
    op Operations::Page::Load

    if model.is_a? ContentPage
      add_breadcrumb model.title
      enable_sidebar_layout if op.model.use_sidebar?
    else
      redirect_to model.redirects_to, allow_other_host: true
    end
  end
end
