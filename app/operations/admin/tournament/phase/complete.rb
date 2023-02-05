module Operations::Admin::Tournament::Phase
  class Complete < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    lock_mode :exclusive

    model ::Tournament::Phase

    policy do
      # We can only set a running phase to be completed
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Wrong status to complete the phase') unless model.running?

      # We must make sure there are no more matches that are
      # not completed yet.
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Not all matches are completed') unless model.rounds.all?(&:completed?)
    end

    def perform
      model.completed!
    end
  end

  class WrongStatus < StandardError; end
  class UncompletedMatches < StandardError; end
end
