class TournamentsController < ApplicationController
  def index
    op Operations::Tournament::Index
  end

  def show
    op Operations::Tournament::Load
  end
end
