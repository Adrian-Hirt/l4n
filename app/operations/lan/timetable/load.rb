module Operations::Lan::Timetable
  class Load < RailsOps::Operation::Model
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :read_public, model
    end

    model ::Timetable

    def lan_party
      @lan_party ||= LanParty.find(osparams.id)
    end

    def model
      @model ||= lan_party.timetable
    end
  end
end
