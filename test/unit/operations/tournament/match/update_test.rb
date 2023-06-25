require 'test_helper'

module Unit
  module Operations
    module Tournament
      module Match
        class UpdateTest < ApplicationTest
          setup do
            # Create some users
            store :user_1, create_user
            store :user_2, create_user
            store :user_3, create_user
            store :user_4, create_user
            store :user_5, create_user # Not participating in tournament
            store :admin, create_user(username: 'admin', email: 'admin@example.com')

            # Give the admin user the tournament permission
            create_user_permission(fetch(:admin), :tournament_admin, :manage)
            fetch(:admin).reload

            # Create the abilities for all users we'll use
            store :user_1_ability, ::Ability.new(fetch(:user_1))
            store :user_2_ability, ::Ability.new(fetch(:user_2))
            store :user_3_ability, ::Ability.new(fetch(:user_3))
            store :user_4_ability, ::Ability.new(fetch(:user_4))
            store :user_5_ability, ::Ability.new(fetch(:user_5))
            store :admin_ability, ::Ability.new(fetch(:admin))

            # Create a tournament
            store :tournament_1, create_tournament(status: ::Tournament.statuses[:published])

            # Create a phase for the tournament
            store :phase_1, create_tournament_phase(tournament: fetch(:tournament_1), phase_attrs: { tournament_mode: 'swiss' })

            # Add the users as singleplayer teams
            store :team_1, create_singleplayer_team(fetch(:user_1), fetch(:tournament_1))
            store :team_2, create_singleplayer_team(fetch(:user_2), fetch(:tournament_1))
            store :team_3, create_singleplayer_team(fetch(:user_3), fetch(:tournament_1))
            store :team_4, create_singleplayer_team(fetch(:user_4), fetch(:tournament_1))

            # Generate the rounds. This needs to be done before the seeding can
            # happen.
            ::Operations::Admin::Tournament::Phase::GenerateRounds.run!(
              id:    fetch(:phase_1).id,
              phase: {
                swiss_rounds: 4
              }
            )

            # Seed the four teams. We seed it in a slightly different order
            # than the creation:
            #  - team_1
            #  - team_2
            #  - team_4
            #  - team_3
            ::Operations::Admin::Tournament::Phase::UpdateSeeding.run!(
              id:      fetch(:phase_1).id,
              seeding: {
                seed: 1,
                team: fetch(:team_1).id
              }
            )

            ::Operations::Admin::Tournament::Phase::UpdateSeeding.run!(
              id:      fetch(:phase_1).id,
              seeding: {
                seed: 2,
                team: fetch(:team_2).id
              }
            )

            ::Operations::Admin::Tournament::Phase::UpdateSeeding.run!(
              id:      fetch(:phase_1).id,
              seeding: {
                seed: 4,
                team: fetch(:team_3).id
              }
            )

            ::Operations::Admin::Tournament::Phase::UpdateSeeding.run!(
              id:      fetch(:phase_1).id,
              seeding: {
                seed: 3,
                team: fetch(:team_4).id
              }
            )

            # Confirm the seeding
            ::Operations::Admin::Tournament::Phase::ConfirmSeeding.run!(id: fetch(:phase_1).id)

            # And finally generate the matches for the first round
            ::Operations::Admin::Tournament::Phase::GenerateNextRoundMatches.run!(id: fetch(:phase_1).id)

            # Set the matches to the placeholders, such that we can access them
            # later in the tests
            store :match_1, fetch(:phase_1).matches.first
            store :match_2, fetch(:phase_1).matches.second

            # Store the phase_teams
            store :team_1_phase_team, fetch(:team_1).phase_teams.first
            store :team_2_phase_team, fetch(:team_2).phase_teams.first
            store :team_3_phase_team, fetch(:team_3).phase_teams.first
            store :team_4_phase_team, fetch(:team_4).phase_teams.first
          end

          def test_setup_correctly
            # Check that the setup is correctly. We have 4 rounds, but no matches
            # for the second round yet.
            assert_equal 4, fetch(:phase_1).rounds.count
            assert_equal 2, fetch(:phase_1).matches.count

            # Check that user_1 and user_3 have a match they play against each other
            # and that the user_2 and user_4 have a match they play against each other.
            # We know this because of the seeding and the logic of the single elim
            # seeding.
            assert_equal fetch(:team_1), fetch(:match_1).home.team
            assert_equal fetch(:team_4), fetch(:match_1).away.team

            assert_equal fetch(:team_2), fetch(:match_2).home.team
            assert_equal fetch(:team_3), fetch(:match_2).away.team

            # Check that each of the matches has the correct state
            assert_equal ::Tournament::Match.result_statuses[:missing], fetch(:match_1).result_status
            assert_equal ::Tournament::Match.result_statuses[:missing], fetch(:match_2).result_status
          end

          def test_abilities_from_initial_state
            # Here we test that each of the allowed users may update the
            # score of their own match, but not of the other match
            assert fetch(:user_1_ability).can?(:update_score, fetch(:match_1))
            assert fetch(:user_4_ability).can?(:update_score, fetch(:match_1))
            assert fetch(:user_2_ability).can?(:update_score, fetch(:match_2))
            assert fetch(:user_3_ability).can?(:update_score, fetch(:match_2))

            assert fetch(:user_1_ability).cannot?(:update_score, fetch(:match_2))
            assert fetch(:user_4_ability).cannot?(:update_score, fetch(:match_2))
            assert fetch(:user_2_ability).cannot?(:update_score, fetch(:match_1))
            assert fetch(:user_3_ability).cannot?(:update_score, fetch(:match_1))

            # Admin user should NOT be able to use this operation, as the
            # admin needs to use the operation in the admin panel to correctly
            # update the match score
            assert fetch(:admin_ability).cannot?(:update_score, fetch(:match_1))
            assert fetch(:admin_ability).cannot?(:update_score, fetch(:match_2))

            # User 5 should not be able to do anything
            assert fetch(:user_5_ability).cannot?(:update_score, fetch(:match_1))
            assert fetch(:user_5_ability).cannot?(:update_score, fetch(:match_2))
          end

          def test_running_operations_from_initial_state
            # Here we run the operation to update the score as one of the teams
            # of each match respectively. After that, the team that submitted
            # the score should not be able to run the operation again, however the
            # other team should be able to confirm or dispute the score.

            # We first try to run the operation as user_5 and admin, as these
            # should fail. Here, already instantiating the operation should
            # fail, so we can simply use the `build_op` helper. We just pass
            # in the ID, the other params aren't required by the schema
            %i[admin user_5].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id
                end

                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id
                end
              end
            end

            # -------------------------------------------------
            # initial submit of result
            # -------------------------------------------------

            # Update the score as user_1 for match_1 (home)
            as_user fetch(:user_1) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                               tournament_match: {
                                                                 winner_id:  fetch(:team_1_phase_team).id,
                                                                 home_score: 12,
                                                                 away_score: 5
                                                               }
            end

            # Check everything was set correctly
            fetch(:match_1).reload
            assert fetch(:match_1).result_reported?
            assert_equal fetch(:team_1), fetch(:match_1).winner.team
            assert_not fetch(:match_1).draw?
            assert_equal 12, fetch(:match_1).home_score
            assert_equal 5, fetch(:match_1).away_score

            # Update the score as user_3 for match_2 (away)
            as_user fetch(:user_3) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_2).id,
                                                               tournament_match: {
                                                                 draw:       true,
                                                                 home_score: 4,
                                                                 away_score: 4
                                                               }
            end

            # Check everything was set correctly
            fetch(:match_2).reload
            assert fetch(:match_2).result_reported?
            assert_nil fetch(:match_2).winner
            assert fetch(:match_2).draw?
            assert_equal 4, fetch(:match_2).home_score
            assert_equal 4, fetch(:match_2).away_score

            # -------------------------------------------------
            # Check reporting users cannot change anymore
            # -------------------------------------------------

            # user_1 and user_3 now should not be able to again run the operations
            # for their respective matches. Instantiating the operation however should work
            as_user fetch(:user_1) do
              build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id

              # TODO: Check exception message
              assert_raises ::Operations::Exceptions::OpFailed do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_2_phase_team).id,
                                                                   home_score: 13,
                                                                   away_score: 6
                                                                 }
              end
            end

            # Check everything still unchanged
            fetch(:match_1).reload
            assert fetch(:match_1).result_reported?
            assert_equal fetch(:team_1), fetch(:match_1).winner.team
            assert_not fetch(:match_1).draw?
            assert_equal 12, fetch(:match_1).home_score
            assert_equal 5, fetch(:match_1).away_score

            as_user fetch(:user_3) do
              build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id

              # TODO: Check exception message
              assert_raises ::Operations::Exceptions::OpFailed do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_2).id,
                                                                 tournament_match: {
                                                                   draw:       true,
                                                                   home_score: 6,
                                                                   away_score: 6
                                                                 }
              end
            end

            # Check everything was set correctly
            fetch(:match_2).reload
            assert fetch(:match_2).result_reported?
            assert_nil fetch(:match_2).winner
            assert fetch(:match_2).draw?
            assert_equal 4, fetch(:match_2).home_score
            assert_equal 4, fetch(:match_2).away_score

            # -------------------------------------------------
            # Check other users still forbidden
            # -------------------------------------------------

            # User_1 and user_4 still cannot change anything about match_2
            %i[user_1 user_4].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id
                end
              end
            end

            # User_3 and user_2 still cannot change anything about match_1
            %i[user_3 user_2].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id
                end
              end
            end

            # User_5 and admin user still should not be able to do anything
            %i[admin user_5].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id
                end
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id
                end
              end
            end

            # -------------------------------------------------
            # Confirm / dispute result as other user
            # -------------------------------------------------

            # User 4 disputes the result for match_1 (away)
            as_user fetch(:user_4) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                               tournament_match: {
                                                                 confirmation: false
                                                               }
            end

            # Check everything was set correctly
            fetch(:match_1).reload
            assert fetch(:match_1).result_disputed?
            assert_equal fetch(:team_1), fetch(:match_1).winner.team
            assert_not fetch(:match_1).draw?
            assert_equal 12, fetch(:match_1).home_score
            assert_equal 5, fetch(:match_1).away_score

            # User 2 confirms the result for match_2 (home)
            as_user fetch(:user_2) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_2).id,
                                                               tournament_match: {
                                                                 confirmation: true
                                                               }
            end

            # Check everything was set correctly
            fetch(:match_2).reload
            assert fetch(:match_2).result_confirmed?
            assert_nil fetch(:match_2).winner
            assert fetch(:match_2).draw?
            assert_equal 4, fetch(:match_2).home_score
            assert_equal 4, fetch(:match_2).away_score

            # -------------------------------------------------
            # Now, all of the users should not be able to
            # run the update operation anymore
            # -------------------------------------------------

            # The users partaking in their respective matches still
            # can instantiate the operation, but not run it anymore

            %i[user_1 user_4].each do |user|
              as_user fetch(user) do
                build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id

                # TODO: Check exception message
                assert_raises ::Operations::Exceptions::OpFailed do
                  run_op! ::Operations::Tournament::Match::Update, id: fetch(:match_1).id, tournament_match: {}
                end
              end
            end

            %i[user_2 user_3].each do |user|
              as_user fetch(user) do
                build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id

                # TODO: Check exception message
                assert_raises ::Operations::Exceptions::OpFailed do
                  run_op! ::Operations::Tournament::Match::Update, id: fetch(:match_2).id, tournament_match: {}
                end
              end
            end

            # User_5 and admin user still should not be able to do anything
            %i[admin user_5].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id
                end
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id
                end
              end
            end

            # Trying to instantiate the operation for the other match should fail
            %i[user_1 user_4].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_2).id
                end
              end
            end

            %i[user_2 user_3].each do |user|
              as_user fetch(user) do
                assert_raises CanCan::AccessDenied do
                  build_op ::Operations::Tournament::Match::Update, id: fetch(:match_1).id
                end
              end
            end
          end

          def test_draw_xor_winner
            # Here we try to set the winner and the draw to true,
            # which should fail, as this does not make sense

            # Update the score as user_1 for match_1 (home)
            as_user fetch(:user_1) do
              assert_raises ActiveRecord::RecordInvalid do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_1_phase_team).id,
                                                                   home_score: 12,
                                                                   away_score: 5,
                                                                   draw:       true
                                                                 }
              end
            end

            # Check that nothing was changed in the database
            fetch(:match_1).reload
            assert fetch(:match_1).result_missing?
            assert_nil fetch(:match_1).winner
            assert_not fetch(:match_1).draw?
            assert_equal 0, fetch(:match_1).home_score
            assert_equal 0, fetch(:match_1).away_score
          end

          def test_winner_id_must_be_home_or_away_team
            # Here, we try to set the winner ID of the match_1 to the team_2,
            # which does not participate in this match. This should fail

            # Try to set to an existing team
            as_user fetch(:user_1) do
              assert_raises ActiveRecord::RecordInvalid do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_2_phase_team).id,
                                                                   home_score: 12,
                                                                   away_score: 5
                                                                 }
              end
            end

            # Check that nothing was changed in the database
            fetch(:match_1).reload
            assert fetch(:match_1).result_missing?
            assert_nil fetch(:match_1).winner
            assert_not fetch(:match_1).draw?
            assert_equal 0, fetch(:match_1).home_score
            assert_equal 0, fetch(:match_1).away_score

            # Try to set to a team which does not exist
            as_user fetch(:user_1) do
              assert_raises ActiveRecord::RecordInvalid do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  0,
                                                                   home_score: 12,
                                                                   away_score: 5
                                                                 }
              end
            end

            # Check that nothing was changed in the database
            fetch(:match_1).reload
            assert fetch(:match_1).result_missing?
            assert_nil fetch(:match_1).winner
            assert_not fetch(:match_1).draw?
            assert_equal 0, fetch(:match_1).home_score
            assert_equal 0, fetch(:match_1).away_score
          end

          def test_scores_updated_correctly
            # Here, we test that the scores are updated correctly. Every team should start
            # with 0 points
            %i[team_1_phase_team team_2_phase_team team_3_phase_team team_4_phase_team].each do |team|
              assert_equal 0, fetch(team).score
            end

            # -------------------------------------------------
            # match_1 won by team_1
            # -------------------------------------------------
            # team_1 wins their first match. After submitting, the scores should still be
            # zero, only after confirming should the scores be updated to reflect the win
            as_user fetch(:user_1) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                               tournament_match: {
                                                                 winner_id:  fetch(:team_1_phase_team).id,
                                                                 home_score: 12,
                                                                 away_score: 5
                                                               }
            end

            # All scores should still be zero
            %i[team_1_phase_team team_2_phase_team team_3_phase_team team_4_phase_team].each do |team|
              assert_equal 0, fetch(team).reload.score
            end

            # user_4 confirms the win
            as_user fetch(:user_4) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                               tournament_match: {
                                                                 confirmation: true
                                                               }
            end

            # All scores should still be zero, except for the team_1, which should have
            # the number of points awarded for a win
            %i[team_2_phase_team team_3_phase_team team_4_phase_team].each do |team|
              assert_equal 0, fetch(team).reload.score
            end

            assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_1_phase_team).reload.score

            # -------------------------------------------------
            # match_2 draw
            # -------------------------------------------------
            as_user fetch(:user_2) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_2).id,
                                                               tournament_match: {
                                                                 draw:       true,
                                                                 home_score: 2,
                                                                 away_score: 2
                                                               }
            end

            # All scores should still be zero, except for the team_1, which should have
            # the number of points awarded for a win
            %i[team_2_phase_team team_3_phase_team team_4_phase_team].each do |team|
              assert_equal 0, fetch(team).reload.score
            end

            assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_1_phase_team).score

            # user_3 confirms the win
            as_user fetch(:user_3) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_2).id,
                                                               tournament_match: {
                                                                 confirmation: true
                                                               }
            end

            assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_1_phase_team).reload.score
            assert_equal ::Tournament::Match::DRAW_SCORE, fetch(:team_2_phase_team).reload.score
            assert_equal ::Tournament::Match::DRAW_SCORE, fetch(:team_3_phase_team).reload.score
            assert_equal 0, fetch(:team_4_phase_team).reload.score
          end

          def test_confirm_cannot_change_winner
            # Here we test that with confirmation user cannot change winner

            # Submit the score as the user_1, where the team_1 has won the match
            as_user fetch(:user_1) do
              run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                               tournament_match: {
                                                                 winner_id:  fetch(:team_1_phase_team).id,
                                                                 home_score: 12,
                                                                 away_score: 5
                                                               }
            end

            # Check everything was set correctly
            fetch(:match_1).reload
            assert fetch(:match_1).result_reported?
            assert_equal fetch(:team_1), fetch(:match_1).winner.team
            assert_not fetch(:match_1).draw?
            assert_equal 12, fetch(:match_1).home_score
            assert_equal 5, fetch(:match_1).away_score

            # Now try to change the score and winner as the user_4 while confirming the score
            as_user fetch(:user_4) do
              # TODO: check message
              assert_raises ::Operations::Exceptions::OpFailed do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:    fetch(:team_4_phase_team).id,
                                                                   home_score:   2,
                                                                   away_score:   15,
                                                                   confirmation: true
                                                                 }
              end
            end

            # Check everything is still right
            fetch(:match_1).reload
            assert fetch(:match_1).result_reported?
            assert_equal fetch(:team_1), fetch(:match_1).winner.team
            assert_not fetch(:match_1).draw?
            assert_equal 12, fetch(:match_1).home_score
            assert_equal 5, fetch(:match_1).away_score
          end

          private

          def create_singleplayer_team(user, tournament)
            team = ::Tournament::Team.create!(
              tournament: tournament,
              name:       user.username,
              status:     ::Tournament::Team.statuses[:registered]
            )

            team.team_members.create!(
              user:    user,
              captain: true
            )

            team
          end
        end
      end
    end
  end
end
