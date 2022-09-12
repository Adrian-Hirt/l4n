module Operations::Tournament::Match
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament_match do
        int? :winner_id, cast_str: true
        boo? :draw, cast_str: true
        obj? :home_score
        obj? :away_score
        boo? :confirmation, cast_str: true
      end
    end

    model ::Tournament::Match do
      attribute :confirmation
    end

    policy :on_init do
      # Check that the match is in a phase with the status "running"
      fail Operations::Exceptions::OpFailed, _('Match|Phase not updateable') unless model.phase.running?

      # Check that the match is in the current round
      fail Operations::Exceptions::OpFailed, _('Match|Match not in current round') unless model.round == model.phase.current_round

      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.home.team.captain?(context.user) || model.away.team.captain?(context.user)
    end

    def perform
      # Check that the match is in a state where the score can be updated. We only do this when executing the operation
      fail Operations::Exceptions::OpFailed, _('Team|Cannot update score in wrong status') unless model.result_missing? || model.result_reported?

      # If we're in the state "reported", only the other team can confirm or
      # dispute the score, the reporting team cannot do that.
      if model.result_reported?
        fail Operations::Exceptions::OpFailed, _('Team|The other team needs to confirm the score!') if user_team == model.reporter

        # Also check that we're not double-submitting anything
        fail Operations::Exceptions::OpFailed, _('Team|The other team already reported the score, please confirm the score!') if osparams.tournament_match[:winner_id].present?
      end

      # If we're missing the result, it can be entered, and then needs to be
      # confirmed. When it's reported, we can only confirm the result.
      if model.result_missing?
        # Update result but don't give out scores yet.
        model.winner_id = osparams.tournament_match[:winner_id]
        model.draw = osparams.tournament_match[:draw]
        model.home_score = osparams.tournament_match[:home_score]
        model.away_score = osparams.tournament_match[:away_score]

        # Set draw to false if not given
        model.draw = false if model.draw.nil?

        # If winner is present or result is a draw, we consider
        # the result reported and set the needed fields
        if model.draw? || model.winner.present?
          # Update the status
          model.result_status = Tournament::Match.result_statuses[:reported]

          # Save who reported the score
          model.reporter = user_team
        else
          model.errors.add(:winner_id, _('Match|Please set the winner'))
          fail ActiveRecord::RecordInvalid
        end

        # Save the model
      else
        # Fail if the user did not submit anything
        if osparams.tournament_match[:confirmation].nil?
          model.errors.add(:confirmation, _('Match|Please select a confirmation status'))
          fail ActiveRecord::RecordInvalid
        end

        # If the confirmation is true, we can set the result as confirmed
        # and update the scores.
        # Otherwise we need to set it to disputed, which will be resolved
        # by an admin.
        if osparams.tournament_match[:confirmation] == true
          model.result_status = Tournament::Match.result_statuses[:confirmed]

          if model.draw?
            model.home.score += Tournament::Match::DRAW_SCORE
            model.home.save!

            model.away.score += Tournament::Match::DRAW_SCORE
            model.away.save!
          else
            model.winner.score += Tournament::Match::WIN_SCORE
            model.winner.save!
          end
        else
          model.result_status = Tournament::Match.result_statuses[:disputed]
        end

      end
      model.save!
    end

    private

    def user_team
      if model.away.team.users.include?(context.user)
        model.away
      else
        model.home
      end
    end
  end
end
