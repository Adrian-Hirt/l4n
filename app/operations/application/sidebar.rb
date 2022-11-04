module Operations::Application
  class Sidebar < RailsOps::Operation
    schema3 {} # No params here

    def first_block
      'This is the first block of the sidebar'
    end

    def lan_party_block
      ApplicationController.render partial: 'shared/sidebar/lan_party_info', locals: { lan_party: LanParty.active } if LanParty.active.present?
    end
  end
end
