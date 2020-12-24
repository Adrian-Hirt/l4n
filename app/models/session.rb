class Session < ActiveRecord::SessionStore::Session
  EXPIRATION_TIME = 1.day
end
