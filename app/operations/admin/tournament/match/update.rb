module Operations::Admin::Tournament::Match
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int? :id, cast_str: true
      hsh? :tournament_match do
        str? :winner_id
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
        if previous_winner_from_db.present?
          previous_winner_from_db.score -= Tournament::Match::WIN_SCORE
          previous_winner_from_db.save!
        end

        super

        new_winner = model.reload.winner&.phase_teams&.find_by(tournament_phase_id: model.phase)

        if new_winner.present?
          new_winner.score += Tournament::Match::WIN_SCORE
          new_winner.save!
        end
      end
    end

    private

    def previous_winner_from_db
      @previous_winner_from_db ||= ::Tournament::Match.find_by(id: osparams.id).winner&.phase_teams&.find_by(tournament_phase_id: model.phase)
    end
  end

  class MatchNotInRunningPhase < StandardError; end
  class MatchNotInCurrentRound < StandardError; end
end
