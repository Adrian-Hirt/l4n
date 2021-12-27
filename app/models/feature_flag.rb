class FeatureFlag < ApplicationRecord
  ################################### Attributes ###################################

  ################################### Constants ####################################
  AVAILABLE_FLAGS = %w[
    events
    news_posts
    pages
    user_registration
  ].freeze

  ################################### Associations #################################

  ################################### Validations ##################################
  validates :key, presence: true, uniqueness: { case_sensitive: true }, inclusion: { in: AVAILABLE_FLAGS }
  validates :enabled, inclusion: [true, false]

  ################################### Hooks #######################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################
  def self.enabled?(key)
    !!find_by(key: key)&.enabled?
  end
end
