class Item < ApplicationRecord
  belongs_to :list
  acts_as_list scope: :list

  has_many :label_assignments, as: :labelable, dependent: :destroy, inverse_of: :labelable
  has_many :labels, through: :label_assignments

  validates :name, uniqueness: { scope: :list_id }, presence: true
end
