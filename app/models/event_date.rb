class EventDate < ApplicationRecord
  ################################### Attributes ###################################

  ################################### Constants ####################################

  ################################### Associations #################################
  belongs_to :event

  ################################### Validations ##################################
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :no_date_overlap
  validate :end_date_at_least_start

  ################################### Hooks #######################################

  ################################### Scopes #######################################
  scope :future, -> { where('(start_date >= ?) OR (start_date <= ? AND end_date >= ?)', Time.zone.today, Time.zone.today, Time.zone.today) }
  scope :past, -> { where('(start_date < ?) OR (start_date > ? AND end_date < ?)', Time.zone.today, Time.zone.today, Time.zone.today) }

  ################################### Class Methods ################################

  ################################### Instance Methods #############################

  ################################### Private Methods ##############################
  private

  def no_date_overlap
    return unless event.event_dates.any? { |e| overlaps?(e) && e != self }

    errors.add(:start_date, _('EventDate|Overlaps with another date'))
    errors.add(:end_date, _('EventDate|Overlaps with another date'))
  end

  def end_date_at_least_start
    return if start_date.nil? || end_date.nil?

    errors.add(:end_date, _('EventDate|Needs to be at larger or equal to the start date')) if start_date > end_date
  end

  def overlaps?(other)
    start_date <= other.end_date && other.start_date <= end_date
  end
end
