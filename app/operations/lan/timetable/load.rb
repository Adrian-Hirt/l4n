module Operations::Lan::Timetable
  class Load < RailsOps::Operation::Model
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :read_public, Timetable
    end

    model ::Timetable

    def lan_party
      @lan_party ||= begin
        lan_party = LanParty.find_by(id: osparams.id)

        fail ActiveRecord::RecordNotFound if lan_party.nil? || !lan_party.active? || !lan_party.timetable_enabled?

        lan_party
      end
    end

    def model
      @model ||= lan_party.timetable
    end
  end
end
