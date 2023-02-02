class Seat < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :seat_map
  belongs_to :seat_category
  belongs_to :ticket, optional: true

  # == Validations =================================================================

  # == Hooks =======================================================================
  before_destroy :check_if_deletable

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def color
    if ticket
      'red'
    else
      seat_category.color_for_view
    end
  end

  def name_or_id
    name.presence || id
  end

  def deleteable?
    ticket.nil?
  end

  # == Private Methods =============================================================
  private

  def check_if_deletable
    throw :abort unless deleteable?
  end
end
