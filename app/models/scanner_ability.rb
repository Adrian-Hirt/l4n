class ScannerAbility
  include CanCan::Ability

  def initialize(scanner_user)
    return if scanner_user.nil?

    ##############################################################
    # Default Permissions
    ##############################################################

    # For now, always can use the scanner
    can :use, :ticket_scanner
  end
end
