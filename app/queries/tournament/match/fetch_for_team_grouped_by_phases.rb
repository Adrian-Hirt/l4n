module Queries::Tournament::Match
  class FetchForTeamGroupedByPhases < Inquery::Query
    schema3 do
      obj! :team
    end

    delegate :team, to: :osparams

    def call
      return ::Tournament::Match.none unless team.tournament.published?

      phase_team_ids = ::Tournament::PhaseTeam.where(team: team).pluck(:id)

      rel = ::Tournament::Match.where('away_id IN (?) OR home_id IN (?)', phase_team_ids, phase_team_ids).order(:id)

      rel.includes(:winner, round: :phase, away: :team, home: :team).group_by(&:phase)
    end
  end
end
