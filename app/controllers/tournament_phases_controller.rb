class TournamentPhasesController < ApplicationController
  add_breadcrumb _('Tournaments'), :tournaments_path

  def index
    op Operations::Tournament::TournamentPhases::Index

    add_breadcrumb op.tournament.name, op.tournament
    add_breadcrumb _('Tournament|Standings')
  end
end
