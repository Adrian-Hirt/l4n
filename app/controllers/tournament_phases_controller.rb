class TournamentPhasesController < ApplicationController
  def index
    op Operations::Tournament::TournamentPhases::Index
  end
end
