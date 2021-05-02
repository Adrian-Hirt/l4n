class Session < ActiveRecord::SessionStore::Session
  ################################### Attributes ###################################

  ################################### Constants ####################################
  EXPIRATION_TIME = 1.day
  REMEMBER_ME_USER_COOKIE = '_l4n_user_id'.freeze
  REMEMBER_ME_TOKEN_COOKIE = '_l4n_remember_token'.freeze

  ################################### Associations #################################

  ################################### Validations ##################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################

  ################################### Private Methods ##############################
end
