class Tournament < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    draft:     'draft',
    published: 'published',
    archived:  'archived'
  }

  translate_enums

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :phases, class_name: 'Tournament::Phase', dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many_attached :files
  belongs_to :lan_party, optional: true

  has_many :tournament_team_ranks, class_name: 'Tournament::TeamRank', dependent: :destroy
  accepts_nested_attributes_for :tournament_team_ranks, allow_destroy: true

  has_many :user_tournament_permissions
  has_many :permitted_users, through: :user_tournament_permissions, source: :user
  accepts_nested_attributes_for :user_tournament_permissions, allow_destroy: true

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :team_size, presence: true, numericality: { greater_than: 0 }
  validates :team_size, numericality: { equal_to: 1 }, if: :singleplayer
  validates :team_size, numericality: { greater_than: 1 }, unless: :singleplayer
  validates :status, presence: true, inclusion: statuses.keys
  validates_boolean :registration_open
  validates_boolean :singleplayer
  validates_boolean :teams_need_rank
  validates :max_number_of_participants, presence: true
  validate :disallow_changes_when_teams_present
  validate :max_number_of_participants_larger_than_in_tournament_teams
  validates :frontend_order, presence: true, numericality: true

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

  def running_phases?
    phases.any?(&:running?)
  end

  # == Private Methods =============================================================
  private

  def disallow_changes_when_teams_present
    # Nothing to do if there are no teams
    return if teams.none?

    # Team size cannot be changed when teams are present
    errors.add(:team_size, _('Tournament|Cannot be changed if teams are present')) if team_size_changed?

    # The singleplayer flag cannot be changed if teams are present
    errors.add(:singleplayer, _('Tournament|Cannot be changed if teams are present')) if singleplayer_changed?

    # The Teams need rank flag cannot be changed if teams are present
    errors.add(:teams_need_rank, _('Tournament|Cannot be changed if teams are present')) if teams_need_rank_changed?
  end

  def max_number_of_participants_larger_than_in_tournament_teams
    # If we have some teams, the number must be larger than the current number of
    # in_tournament teams. Otherwise, it just needs to be larger than 0.
    if teams.in_tournament.none? && max_number_of_participants <= 0
      errors.add(:max_number_of_participants, _('must be larger than 0'))
    elsif max_number_of_participants < teams.in_tournament.count
      errors.add(:max_number_of_participants, _('must be larger or equal than the number of teams (currently %{number})') % { number: teams.in_tournament.count })
    end
  end
end
