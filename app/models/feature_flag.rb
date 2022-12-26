class FeatureFlag < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  AVAILABLE_FLAGS = %w[
    events
    news_posts
    pages
    user_registration
    shop
    lan_party
    tournaments
    frontend_sidebar
    api_and_oauth
  ].freeze

  # == Associations ================================================================

  # == Validations ================================================================
  validates :key, presence: true, uniqueness: { case_sensitive: true }, inclusion: { in: AVAILABLE_FLAGS }
  validates_boolean :enabled

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.enabled?(key)
    Rails.cache.fetch("feature_flag/#{key}") do
      !!find_by(key: key)&.enabled?
    end
  end

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
