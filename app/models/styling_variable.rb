class StylingVariable < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  AVAILABLE_KEYS = %w[
    --l4n-accent-color
    --l4n-bg-color
    --l4n-text-color
    --l4n-button-text-color
    --l4n-button-focus-color
    --l4n-button-focus-shadow-color
    --l4n-footer-bg
    --l4n-card-bg-color
  ].freeze

  # == Associations ================================================================

  # == Validations =================================================================
  validates :key, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }, inclusion: { in: AVAILABLE_KEYS }
  validates :value, presence: true, length: { maximum: 255 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.generate_css
    Rails.cache.fetch('l4n/styling-variables') do
      if none?
        ''
      else
        output = [':root {']

        all.find_each do |styling_variable|
          output << "#{styling_variable.key}: #{styling_variable.value};"
        end

        output << '}'
        output.join("\n")
      end
    end
  end

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
