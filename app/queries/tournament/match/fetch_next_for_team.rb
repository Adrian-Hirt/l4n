module Queries::Tournament::Match
  class FetchNextForTeam < Inquery::Query
    schema3 do
      obj! :team
    end

    def call
      return ::Tournament::Match.none unless osparams.team.tournament.published?

      phase_team_ids = ::Tournament::PhaseTeam.where(team: osparams.team).pluck(:id)

      ::Tournament::Match.where('away_id IN (?) OR home_id IN (?)', phase_team_ids, phase_team_ids)
                         .where("result_status = 'missing' OR result_status = 'reported'")
                         .order(id: :desc).last
    end
  end
end
