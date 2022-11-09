class EventsController < ApplicationController
  before_action :enable_sidebar_layout

  add_breadcrumb _('Events'), :events_path

  def index
    op Operations::Event::Index
  end

  def show
    op Operations::Event::Load
    add_breadcrumb model.title
  end
end
