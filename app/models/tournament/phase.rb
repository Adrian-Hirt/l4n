class Tournament::Phase < ApplicationRecord
  # == Attributes ==================================================================
  enum tournament_mode: {
    swiss:              'swiss',
    single_elimination: 'single_elimination',
    double_elimination: 'double_elimination'
  }

  enum status: {
    created:   'created',   # Freshly created
    seeding:   'seeding',   # In seeding, where rounds have been generated but seeding not completed
    confirmed: 'confirmed', # Seeding confirmed, matches can be generated
    running:   'running',   # Matches are being played
    completed: 'completed'  # All matches have been played and results can be calculated
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :rounds, class_name: 'Tournament::Round', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :phase
  has_many :phase_teams, class_name: 'Tournament::PhaseTeam', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :phase
  has_many :teams, through: :phase_teams
  has_many :seeded_teams, -> { order('tournament_phase_teams.seed') }, through: :phase_teams, source: :team
  has_many :matches, through: :rounds

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :phase_number, presence: true, numericality: { greater_than: 0 }
  validates :tournament_mode, presence: true, inclusion: tournament_modes.keys
  validates :status, presence: true, inclusion: statuses.keys
  validates :size, presence: true, numericality: { greater_than: 0 }, unless: :first_phase?
  validate :tournament_must_allow_another_phase, on: :create
  validate :disallow_changes_when_not_created

  # == Hooks =======================================================================
  before_destroy :check_if_deletable

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def generator_class
    if swiss?
      TournamentSystem::Swiss
    # elsif round_robin?
    #   TournamentSystem::RoundRobin
    elsif single_elimination?
      TournamentSystem::SingleElimination
    elsif double_elimination?
      TournamentSystem::DoubleElimination
    else
      fail 'Invalid tournament mode!'
    end
  end

  def first_phase?
    tournament.phases.none? || tournament.phases.order(:phase_number).first.id == id
  end

  def previous_phase
    tournament.phases.where('phase_number < ?', phase_number).order(phase_number: :desc).first
  end

  def seedable_teams
    if first_phase?
      # If we're the first phase, we get all teams from the tournament which are in
      # status "registered", i.e. all teams which have completed the
      # registration process.
      tournament.teams.where(status: 'registered')
    else
      # Otherwise, we get all teams from the previous phase that qualified themselfes
      # to move on to the next round, and remove the already seeded teams from that
      Queries::Team::FetchRankedWithScoreForPhaseFromPrevious.call(phase: self)
    end
  end

  def participating_teams
    seedable_teams + teams
  end

  def current_round
    return nil if completed?

    rounds.order(round_number: :desc).find { |r| r.matches.any? }
  end

  def next_round
    return nil if completed?

    rounds.order(:round_number).find { |r| r.matches.none? }
  end

  def playing_and_dropped_out_teams
    playing = []

    if running?
      relevant_matches = current_round.matches
    else
      relevant_matches = rounds.order(:round_number).last.matches
    end

    relevant_matches.each do |match|
      if match.winner.present?
        playing << match.winner
      else
        playing << match.home_team
        playing << match.away_team
      end
    end

    dropped_out = teams.to_a - playing.compact

    [playing.compact.sort_by(&:name), dropped_out.sort_by(&:name)]
  end

  def deletable?
    created? && first_phase?
  end

  # == Private Methods =============================================================
  private

  def tournament_must_allow_another_phase
    return if tournament.blank? || tournament.another_phase_possible?

    errors.add(:base, _('Phase|Tournament cannot have another phase'))
  end

  def disallow_changes_when_not_created
    return if created?

    errors.add(:tournament_mode, _('Phase|Cannot change mode when phase is in another state than created')) if tournament_mode_changed?

    errors.add(:size, _('Phase|Cannot change size when phase is in another state than created')) if size_changed?
  end

  def check_if_deletable
    throw :abort unless deletable?
  end
end
