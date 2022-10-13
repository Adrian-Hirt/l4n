module Operations::Admin::Timetable
  class LoadForLanParty < RailsOps::Operation::Model
    schema3 do
      str! :lan_party_id
    end

    policy :on_init do
      authorize! :manage, Timetable
    end

    model ::Timetable

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def model
      @model ||= lan_party.timetable
    end
  end
end
