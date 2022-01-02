class MenuLinkItem < MenuItem
  ################################### Attributes ###################################

  ################################### Constants ####################################

  ################################### Associations #################################
  belongs_to :parent, class_name: 'MenuDropdownItem', optional: true

  ################################### Validations ##################################
  validates :page_name, presence: true, length: { maximum: 255 }

  # ################################### Hooks #######################################

  # ################################### Scopes #######################################

  # ################################### Class Methods ################################

  # ################################### Instance Methods #############################
  def visible?
    if PREDEFINED_PAGES.key?(page_name)
      FeatureFlag.enabled?(PREDEFINED_PAGES[page_name][:feature_flag])
    else
      Page.find_by(url: page_name).readable?
    end
  end

  alias visible visible?

  # ################################### Private Methods ##############################
end
