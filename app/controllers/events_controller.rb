class EventsController < ApplicationController
  def index
    op Operations::Event::Index
  end

  def show
    op Operations::Event::Load
  end
end
