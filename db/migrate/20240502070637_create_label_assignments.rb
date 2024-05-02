class CreateLabelAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :label_assignments do |t|
      t.references :labelable, polymorphic: true, null: false
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end

    add_index :label_assignments,
              %i[label_id labelable_type labelable_id],
              unique: true,
              name: "index_label_assignments_on_label_and_labelable"
  end
end
