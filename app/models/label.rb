class Label < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }

  has_many :label_assignments, dependent: :destroy
  has_many :items, through: :label_assignments, source: :labelable, source_type: "Item"
  has_many :lists, through: :label_assignments, source: :labelable, source_type: "List"
end
