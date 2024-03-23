class Item < ApplicationRecord
  belongs_to :list

  validates :name, uniqueness: { scope: :list_id }, presence: true
end
