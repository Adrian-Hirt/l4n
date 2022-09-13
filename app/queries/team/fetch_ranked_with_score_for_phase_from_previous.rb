module Queries::Team
  class FetchRankedWithScoreForPhaseFromPrevious < Inquery::Query
    schema3 do
      obj! :phase
    end

    def call
      previous_phase = osparams.phase.previous_phase

      rel = ::Tournament::Team.joins(:phase_teams)
                              .select('tournament_teams.*, tournament_phase_teams.score AS score, tournament_phase_teams.score AS seed')
                              .where(tournament_phase_teams: { tournament_phase_id: previous_phase.id })
                              .order('tournament_phase_teams.score DESC, tournament_phase_teams.seed ASC')
                              .limit(osparams.phase.size)

      ::Tournament::Team.select('*')
                        .from("(#{rel.to_sql}) AS tournament_teams")
                        .where.not(tournament_teams: { id: osparams.phase.teams })
                        .order('score DESC, seed ASC')
    end
  end
end
