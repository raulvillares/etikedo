class LabelAssignment < ApplicationRecord
  belongs_to :labelable, polymorphic: true
  belongs_to :label

  after_destroy :check_label_unassigned

  private

  def check_label_unassigned
    label.destroy if label.label_assignments.reload.empty?
  end
end
