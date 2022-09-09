module Operations::Admin::Tournament::Match
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int? :id, cast_str: true
      hsh? :tournament_match do
        int? :winner_id, cast_str: true
        boo? :draw, cast_str: true
      end
    end

    policy :on_init do
      # Check that the match is in a phase with the status "running"
      fail MatchNotInRunningPhase unless model.phase.running?

      # Check that the match is in the current round
      fail MatchNotInCurrentRound unless model.round == model.phase.current_round
    end

    model ::Tournament::Match

    def perform
      # If we added a new winner, we need to add 2 points to the team
      # unless it's already the previous winner (i.e. nothing changed).
      # If we changed the winner, we need to remove the points from the
      # old winner, and add them to the new winner. And if we removed
      # the winner alltogether, we need to subtract the points from the
      # winner as well.
      # For simplicity, we just subtract the winning points from the previous
      # winner (if present), and add them to the new winner (if present).
      # As such, we get the desired behaviour.
      ActiveRecord::Base.transaction do
        if model.draw_was
          previous_home.score -= Tournament::Match::DRAW_SCORE
          previous_home.save!

          previous_away.score -= Tournament::Match::DRAW_SCORE
          previous_away.save!
        elsif previous_winner.present?
          previous_winner.score -= Tournament::Match::WIN_SCORE
          previous_winner.save!
        end

        super

        new_winner = model.winner

        if model.draw?
          model.home.score += Tournament::Match::DRAW_SCORE
          model.home.save!

          model.away.score += Tournament::Match::DRAW_SCORE
          model.away.save!
        elsif new_winner.present?
          new_winner.score += Tournament::Match::WIN_SCORE
          new_winner.save!
        end
      end
    end

    private

    def previous_winner
      @previous_winner ||= ::Tournament::PhaseTeam.find_by(id: model.winner_id_was)
    end

    def previous_home
      @previous_home ||= ::Tournament::PhaseTeam.find_by(id: model.home_id_was)
    end

    def previous_away
      @previous_away ||= ::Tournament::PhaseTeam.find_by(id: model.away_id_was)
    end
  end

  class MatchNotInRunningPhase < StandardError; end
  class MatchNotInCurrentRound < StandardError; end
end
