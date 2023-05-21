require 'test_helper'

module Unit
  module Operations
    module Admin
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
              store :tournament_admin, create_user

              # Give the admin user the tournament permission
              create_user_permission(fetch(:admin), :tournament_admin, :manage)
              fetch(:admin).reload

              # Create a tournament
              store :tournament_1, create_tournament(status: ::Tournament.statuses[:published])

              # Give the tournament admin user the fine-grained permission for
              # the just created tournament
              ::UserTournamentPermission.create!(tournament: fetch(:tournament_1), user: fetch(:tournament_admin))

              # Create the abilities for all users we'll use
              store :user_1_ability, ::Ability.new(fetch(:user_1))
              store :user_2_ability, ::Ability.new(fetch(:user_2))
              store :user_3_ability, ::Ability.new(fetch(:user_3))
              store :user_4_ability, ::Ability.new(fetch(:user_4))
              store :user_5_ability, ::Ability.new(fetch(:user_5))
              store :admin_ability, ::Ability.new(fetch(:admin))
              store :tournament_admin_ability, ::Ability.new(fetch(:tournament_admin))

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

            def test_user_access
              # Test that only the admin has access to the operation
              %i[user_1 user_2 user_3 user_4 user_5].each do |user|
                as_user fetch(user) do
                  assert_raises CanCan::AccessDenied do
                    build_op ::Operations::Admin::Tournament::Match::Update, id: fetch(:match_1).id
                  end

                  assert_raises CanCan::AccessDenied do
                    run_op! ::Operations::Admin::Tournament::Match::Update, id: fetch(:match_1).id
                  end
                end
              end

              %i[admin tournament_admin].each do |user|
                as_user fetch(user) do
                  build_op ::Operations::Admin::Tournament::Match::Update, id: fetch(:match_1).id
                  run_op! ::Operations::Admin::Tournament::Match::Update, id: fetch(:match_1).id
                end
              end
            end

            def test_update_from_initial_state
              # Here we test using the operation from the initial state to directly
              # set the score of a match
              user = fetch(:admin)

              # Update match_1
              as_user user do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  fetch(:team_1).id,
                                                                          home_score: 12,
                                                                          away_score: 5
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_1), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 12, fetch(:match_1).home_score
              assert_equal 5, fetch(:match_1).away_score

              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Now change the winner to the other team
              as_user user do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  fetch(:team_4).id,
                                                                          home_score: 8,
                                                                          away_score: 9
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_4), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 8, fetch(:match_1).home_score
              assert_equal 9, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_4_phase_team).reload.score

              # Now remove the winner
              as_user user do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  nil,
                                                                          home_score: 0,
                                                                          away_score: 0
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_missing?
              assert_nil fetch(:match_1).winner
              assert_not fetch(:match_1).draw?
              assert_equal 0, fetch(:match_1).home_score
              assert_equal 0, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score
            end

            def test_update_from_submitted_state
              # Here we test using the operation from the submitted state, i.e.
              # when one team submitted the result, but the other did not confirm
              # it yet

              # Submit result for match_1
              as_user fetch(:user_1) do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_1).id,
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

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Update match_1 as the admin
              as_user fetch(:admin) do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  fetch(:team_4).id,
                                                                          home_score: 3,
                                                                          away_score: 6
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_4), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 3, fetch(:match_1).home_score
              assert_equal 6, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_4_phase_team).reload.score
            end

            def test_update_from_disputed_state
              # Here we test using the operation from the disputed state, i.e.
              # when one team submitted the result, but the other did dispute the result

              # Submit result for match_1
              as_user fetch(:user_1) do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_1).id,
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

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Dispute the result as user_4
              as_user fetch(:user_4) do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   confirmation: false
                                                                 }
              end

              # Check everything is still as before, except the state
              fetch(:match_1).reload
              assert fetch(:match_1).result_disputed?
              assert_equal fetch(:team_1), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 12, fetch(:match_1).home_score
              assert_equal 5, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Update match_1 as the admin
              as_user fetch(:admin) do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  fetch(:team_4).id,
                                                                          home_score: 3,
                                                                          away_score: 6
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_4), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 3, fetch(:match_1).home_score
              assert_equal 6, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_4_phase_team).reload.score
            end

            def test_update_from_confirmed_state
              # Here we test using the operation from the confirmed state, i.e.
              # when one team submitted the result, and the other confirmed it

              # Submit result for match_1
              as_user fetch(:user_1) do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   winner_id:  fetch(:team_1).id,
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

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Dispute the result as user_4
              as_user fetch(:user_4) do
                run_op! ::Operations::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                 tournament_match: {
                                                                   confirmation: true
                                                                 }
              end

              # Check everything is still as before, except the state
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_1), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 12, fetch(:match_1).home_score
              assert_equal 5, fetch(:match_1).away_score

              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal 0, fetch(:team_4_phase_team).reload.score

              # Update match_1 as the admin
              as_user fetch(:admin) do
                run_op! ::Operations::Admin::Tournament::Match::Update, id:               fetch(:match_1).id,
                                                                        tournament_match: {
                                                                          winner_id:  fetch(:team_4).id,
                                                                          home_score: 3,
                                                                          away_score: 6
                                                                        }
              end

              # Check that the match was updated correctly, and the scores are correct
              fetch(:match_1).reload
              assert fetch(:match_1).result_confirmed?
              assert_equal fetch(:team_4), fetch(:match_1).winner.team
              assert_not fetch(:match_1).draw?
              assert_equal 3, fetch(:match_1).home_score
              assert_equal 6, fetch(:match_1).away_score

              assert_equal 0, fetch(:team_1_phase_team).reload.score
              assert_equal 0, fetch(:team_2_phase_team).reload.score
              assert_equal 0, fetch(:team_3_phase_team).reload.score
              assert_equal ::Tournament::Match::WIN_SCORE, fetch(:team_4_phase_team).reload.score
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
end
