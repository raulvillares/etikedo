class List < ApplicationRecord
  belongs_to :user
  has_many :items, -> { order("position ASC") }, dependent: :destroy, inverse_of: :list
  has_many :label_assignments, as: :labelable, dependent: :destroy, inverse_of: :labelable
  has_many :labels, through: :label_assignments

  validates :title, presence: true, uniqueness: true

  scope :by_user, ->(user) { where user: }
end
