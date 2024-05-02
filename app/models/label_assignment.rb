class LabelAssignment < ApplicationRecord
  belongs_to :labelable, polymorphic: true
  belongs_to :label
end
