class Label < ApplicationRecord
  NORMALIZE_NAME = ->(name) { name.strip.downcase }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  normalizes :name, with: NORMALIZE_NAME

  has_many :label_assignments, dependent: :destroy
  has_many :items, through: :label_assignments, source: :labelable, source_type: "Item"
  has_many :lists, through: :label_assignments, source: :labelable, source_type: "List"

  def self.find_or_create_by_name(name)
    find_or_create_by(name: NORMALIZE_NAME.call(name))
  end
end
