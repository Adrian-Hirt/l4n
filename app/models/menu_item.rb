class MenuItem < ApplicationRecord
  extend Mobility
  translates :title

  PREDEFINED_PAGES = {
    'news'   => { auth_subject: NewsPost, title: _('News') },
    'events' => { auth_subject: Event, title: _('Events') }
  }.freeze

  LINK_TYPE = 'link_type'.freeze
  DROPDOWN_TYPE = 'dropdown_type'.freeze
  ITEM_TYPES = [LINK_TYPE, DROPDOWN_TYPE].freeze

  belongs_to :parent, class_name: 'MenuItem', optional: true
  has_many :children, class_name: 'MenuItem', foreign_key: 'parent_id'

  validates :sort, numericality: { min: 0 }, presence: true
  validates :visible, inclusion: [true, false]
  validates :item_type, inclusion: ITEM_TYPES
  validates :page_name, presence: true, if: :link_type?
  validates :page_name, absence: true, if: :dropdown_type?
  validates :parent_id, absence: true, if: :dropdown_type?

  validates_translated :title, presence: true, length: { maximum: 255 }

  validate :link_item_no_children
  validate :dropdown_item_no_parent

  def link_type?
    item_type == LINK_TYPE
  end

  def dropdown_type?
    item_type == DROPDOWN_TYPE
  end

  private

  def link_item_no_children
    errors.add(:parent_id, 'Parent cannot be a link item') if parent&.link_type?
  end

  def dropdown_item_no_parent
    errors.add(:parent_id, 'A dropdown cannot have a parent') if dropdown_type? && parent.present?
  end
end
