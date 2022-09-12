class Tournament < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    draft:     'draft',
    published: 'published',
    archived:  'archived'
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :phases, class_name: 'Tournament::Phase', dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many_attached :files
  belongs_to :lan_party, optional: true

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :team_size, presence: true, numericality: { greater_than: 0 }
  validates :team_size, numericality: { equal_to: 1 }, if: :singleplayer
  validates :team_size, numericality: { greater_than: 1 }, unless: :singleplayer
  validates :status, presence: true, inclusion: statuses.keys
  validates_boolean :registration_open
  validates_boolean :singleplayer
  validates :max_number_of_participants, presence: true
  validate :disallow_changes_when_teams_present
  validate :max_number_of_participants_larger_than_in_tournament_teams

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  # Another phase only possible if the phase is either the first phase, or the
  # previous phase is either swiss or round_robin. For single and double elim,
  # we only have one winner and as such it does not make sense to have another round
  # after that.
  def another_phase_possible?
    return true if phases.none?

    previous_round = phases.order(phase_number: :desc).first

    previous_round.swiss? # || previous_round.round_robin?
  end

  def teams_full?
    teams.in_tournament.count >= max_number_of_participants
  end

  def ongoing_phases?
    phases.any? { |phase| !phase.created? }
  end

  # == Private Methods =============================================================
  private

  def disallow_changes_when_teams_present
    return if teams.none?

    errors.add(:team_size, _('Tournament|Cannot be changed if teams are present')) if team_size_changed?

    errors.add(:singleplayer, _('Tournament|Cannot be changed if teams are present')) if singleplayer_changed?
  end

  def max_number_of_participants_larger_than_in_tournament_teams
    # If we have some teams, the number must be larger than the current number of
    # in_tournament teams. Otherwise, it just needs to be larger than 0.
    if teams.in_tournament.none? && max_number_of_participants <= 0
      errors.add(:max_number_of_participants, _('must be larger than 0'))
    elsif max_number_of_participants < teams.in_tournament.count
      errors.add(:max_number_of_participants, format(_('must be larger or equal than the number of teams (currently %{number})'), number: teams.in_tournament.count))
    end
  end
end
