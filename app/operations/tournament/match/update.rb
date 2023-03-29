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

    load_model_authorization_action :update_score
    model_authorization_action :update_score

    model ::Tournament::Match do
      attribute :confirmation
    end

    policy :on_init do
      # Check that the match is in a phase with the status "running"
      fail Operations::Exceptions::OpFailed, _('Match|Phase not updateable') unless model.phase.running?

      # Check that the match is in the current round
      fail Operations::Exceptions::OpFailed, _('Match|Match not in current round') unless model.round == model.phase.current_round
    end

    policy :before_perform do
      # Check that the match is in a state where the score can be updated. We only do this when executing the operation
      fail Operations::Exceptions::OpFailed, _('Team|Cannot update score in wrong status') unless model.result_missing? || model.result_reported?

      # If we're in the state "reported", only the other team can confirm or
      # dispute the score, the reporting team cannot do that.
      if model.result_reported?
        fail Operations::Exceptions::OpFailed, _('Team|The other team needs to confirm the score!') if user_team == model.reporter

        # Also check that we're not double-submitting anything
        fail Operations::Exceptions::OpFailed, _('Team|The other team already reported the score, please confirm the score!') if osparams.tournament_match[:winner_id].present? || osparams.tournament_match[:draw].present? || osparams.tournament_match[:home_score].present? || osparams.tournament_match[:away_score].present?
      end
    end

    def perform
      previous_status = model.result_status

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
        # the result reported and set the needed fields. Please note
        # that `reported` only means one team submitted the result,
        # but it's not definitive, as the other team still needs to
        # confirm the score!
        if model.draw? ^ model.winner_id.present?
          # Update the status
          model.result_status = Tournament::Match.result_statuses[:reported]

          # Save who reported the score
          model.reporter = user_team
        elsif !model.draw? && model.winner_id.nil?
          model.errors.add(:winner_id, _('Match|Please set the winner'))
          fail ActiveRecord::RecordInvalid
        end
      else
        # Fail if the user did not submit anything
        if osparams.tournament_match[:confirmation].nil?
          model.errors.add(:confirmation, _('Match|Please select a confirmation status'))
          fail ActiveRecord::RecordInvalid
        end

        # If the confirmation is true, we can set the result as confirmed
        # and update the scores.Operations::Admin::Tournament::Phase
        # Otherwise we need to set it to disputed, which will be resolved
        # by an admin.
        if osparams.tournament_match[:confirmation] == true
          model.result_status = Tournament::Match.result_statuses[:confirmed]

          # Add points if swiss system
          if model.phase.swiss?
            # rubocop: disable Metrics/BlockNesting
            if model.draw?
              model.home.score += Tournament::Match::DRAW_SCORE
              model.home.save!

              model.away.score += Tournament::Match::DRAW_SCORE
              model.away.save!
            else
              model.winner.score += Tournament::Match::WIN_SCORE
              model.winner.save!
            end
            # rubocop: enable Metrics/BlockNesting
          end
        else
          model.result_status = Tournament::Match.result_statuses[:disputed]
        end

      end

      # Save the model
      model.save!

      # Finally, if the match is now confirmed and all other matches are confirmed
      # as well, we can generate the next round if auto_progress is enabled on the
      # phase.
      Operations::Admin::Tournament::Phase::GenerateNextRoundMatches.run!(id: model.phase.id) if model.result_confirmed? && model.round.completed? && model.phase.auto_progress?
    rescue ActiveRecord::RecordInvalid => e
      # Reset the state to the previous one if saving failed
      model.result_status = previous_status

      # And re-raise the exception
      fail e
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
