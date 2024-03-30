class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :title, presence: true, uniqueness: true

  scope :by_user, ->(user) { where user: }
end
