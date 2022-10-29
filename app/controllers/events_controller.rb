class EventsController < ApplicationController
  before_action :enable_sidebar_layout

  def index
    op Operations::Event::Index
  end

  def show
    op Operations::Event::Load
  end
end
