class Session < ActiveRecord::SessionStore::Session
  EXPIRATION_TIME = 1.day
  REMEMBER_ME_USER_COOKIE = '_l4n_user_id'.freeze
  REMEMBER_ME_TOKEN_COOKIE = '_l4n_remember_token'.freeze
end
