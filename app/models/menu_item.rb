class MenuItem < ApplicationRecord
  belongs_to :parent, class_name: 'MenuItem', optional: true
  has_many :children, class_name: 'MenuItem', foreign_key: 'parent_id'

  validates :sort, numericality: { min: 0 }, presence: true
  validates :page_name, presence: true
  validates :visible, inclusion: [true, false]

  validate :parent_has_no_parent
  validate :no_parent_if_children

  private

  def parent_has_no_parent
    errors.add(:parent, 'Parent must not have a parent!') if parent.present? && parent.parent.present?
  end

  def no_parent_if_children
    errors.add(:parent, 'Cannot add a parent if the menu has children') if parent.present? && children.any?
  end
end
