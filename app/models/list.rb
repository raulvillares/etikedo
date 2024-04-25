class List < ApplicationRecord
  belongs_to :user
  has_many :items, -> { order("position ASC") }, dependent: :destroy, inverse_of: :list

  validates :title, presence: true, uniqueness: true

  scope :by_user, ->(user) { where user: }
end
