class Item < ApplicationRecord
  belongs_to :list
  acts_as_list scope: :list

  validates :name, uniqueness: { scope: :list_id }, presence: true
end
