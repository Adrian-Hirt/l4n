module TournamentDrivers
  class DefaultDriver < TournamentSystem::Driver
    def initialize(tournament_phase, tournament_phase_round)
      @tournament_phase = tournament_phase
      @tournament_phase_round = tournament_phase_round

      super()
    end

    # Here we should return all the matches, such that we can calculate
    # the next rounds
    def matches
      @tournament_phase.matches
    end

    # Just return all teams, usually this is just the teams that are
    # "qualified" for the current phase. For most of the tournament
    # systems, we need to seed the teams based on their level.
    # A lower seed means better.
    def seeded_teams
      @tournament_phase.seeded_teams.to_a
    end

    # Return the ranked teams, which currently just takes the seeded
    # teams. We probably need to rank the teams by their score for
    # the swiss system.
    def ranked_teams
      @tournament_phase.teams.order(:score).to_a
    end

    def get_match_winner(match)
      match.winner
    end

    def get_match_teams(match)
      [match.home_team, match.away_team]
    end

    # Here, we get the score for a team, which usually is needed
    # for swiss systems, as we want the stronger teams to play against
    # stronger teams, and weaker teams agains weaker teams
    def get_team_score(team)
      team.score
    end

    def get_team_matches(team)
      # TODO: Implement (where do we need this?)
    end

    def build_match(home_team, away_team)
      ActiveRecord::Base.transaction do
        params = {
          home_team: home_team,
          away_team: away_team
        }

        # If the away_team is nil, we have a bye match and
        # the winner is automatically set to the home team.
        if away_team.nil?
          params[:winner] = home_team

          # We also add bye points to the home_team for swiss.
          if @tournament_phase.swiss?
            home_team.score += Tournament::Match::BYE_SCORE
            home_team.save!
          end
        end

        @tournament_phase_round.matches.create!(params)
      end
    end
  end
end
