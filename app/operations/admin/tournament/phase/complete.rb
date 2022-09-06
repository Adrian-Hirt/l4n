module Operations::Admin::Tournament::Phase
  class Complete < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    policy do
      # We can only set a running phase to be completed
      fail WrongStatus unless model.running?

      # We must make sure there are no more matches that are
      # not completed yet.
      fail UncompletedMatches unless model.rounds.all?(&:completed?)
    end

    def perform
      model.completed!
    end
  end

  class WrongStatus < StandardError; end
  class UncompletedMatches < StandardError; end
end
