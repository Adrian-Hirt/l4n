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
  validates :light_mode_value, length: { maximum: 255 }
  validates :dark_mode_value, length: { maximum: 255 }
  validate :at_least_one_value_set

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.generate_css
    Rails.cache.fetch('l4n/styling-variables') do
      if none?
        ''
      else
        output = []
        light_variables = where.not(light_mode_value: nil)
        dark_variables = where.not(dark_mode_value: nil)

        # Light variables

        if light_variables.any?
          output << 'html[data-bs-theme="light"] {'

          light_variables.each do |styling_variable|
            output << "  #{styling_variable.key}: #{styling_variable.light_mode_value};"
          end

          output << '}'
        end

        if dark_variables.any?
          output << 'html[data-bs-theme="dark"] {'

          dark_variables.each do |styling_variable|
            output << "  #{styling_variable.key}: #{styling_variable.dark_mode_value};"
          end

          output << '}'
        end

        output.join("\n").html_safe
      end
    end
  end

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def at_least_one_value_set
    return if light_mode_value.present? || dark_mode_value.present?

    errors.add(:light_mode_value, _('StylingVariable|Set at least one value'))
    errors.add(:dark_mode_value, _('StylingVariable|Set at least one value'))
  end
end
