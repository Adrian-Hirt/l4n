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
            store :admin, create_user(username: 'admin', email: 'admin@example.com')

            # Give the admin user the tournament permission
            fetch(:admin).toggle!(:tournament_admin_permission) # rubocop:disable Rails/SkipsModelValidations

            # Create a tournament
            store :tournament_1, create_tournament(status: ::Tournament.statuses[:published])

            # Create a phase for the tournament
            store :phase_1, create_tournament_phase(tournament: fetch(:tournament_1))

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

            # Seed the four teams
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
                seed: 3,
                team: fetch(:team_3).id
              }
            )

            ::Operations::Admin::Tournament::Phase::UpdateSeeding.run!(
              id:      fetch(:phase_1).id,
              seeding: {
                seed: 4,
                team: fetch(:team_4).id
              }
            )

            # Confirm the seeding
            ::Operations::Admin::Tournament::Phase::ConfirmSeeding.run!(id: fetch(:phase_1).id)

            # And finally generate the matches for the first round
            ::Operations::Admin::Tournament::Phase::GenerateNextRoundMatches.run!(id: fetch(:phase_1).id)
          end

          def test_setup_correctly
            # Check that the setup is correctly. We have 2 rounds, but no matches
            # for the second round yet.
            assert_equal 2, fetch(:phase_1).rounds.count
            assert_equal 2, fetch(:phase_1).matches.count

            # Check that user_1 and user_3 have a match they play against each other
            # and that the user_2 and user_4 have a match they play against each other.
            # We know this because of the seeding and the logic of the single elim
            # seeding.
            assert_equal fetch(:team_1), fetch(:phase_1).matches.first.home.team
            assert_equal fetch(:team_4), fetch(:phase_1).matches.first.away.team

            assert_equal fetch(:team_2), fetch(:phase_1).matches.second.home.team
            assert_equal fetch(:team_3), fetch(:phase_1).matches.second.away.team
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
