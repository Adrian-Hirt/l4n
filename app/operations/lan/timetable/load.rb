module Operations::Lan::Timetable
  class Load < RailsOps::Operation::Model
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :read, Timetable
    end

    model ::Timetable

    def lan_party
      @lan_party ||= LanParty.find_by(active: true)
    end

    def model
      @model ||= lan_party.timetable
    end
  end
end
