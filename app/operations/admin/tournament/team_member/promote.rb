module Operations::Admin::Tournament::TeamMember
  class Promote < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::TeamMember

    def perform
      # Don't need to do anything if the current team_member is already captain
      return if model.captain?

      # Remove the captain role from the existing captain
      previous_captain = model.team.team_members.find_by(captain: true)
      if previous_captain.present?
        previous_captain.captain = false
        previous_captain.save!
      end

      # Add the captain role to the new captain
      model.captain = true
      model.save!
    end
  end
end
