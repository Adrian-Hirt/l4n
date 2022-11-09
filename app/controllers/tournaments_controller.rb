class TournamentsController < ApplicationController
  add_breadcrumb _('Tournaments'), :tournaments_path

  def index
    op Operations::Tournament::Index
  end

  def show
    op Operations::Tournament::Load
    add_breadcrumb model.name
  end
end
