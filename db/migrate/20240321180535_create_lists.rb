class CreateLists < ActiveRecord::Migration[7.1]
  def change
    create_table :lists do |t|
      t.string :title, null: false, index: { unique: true, name: "unique_emails" }

      t.timestamps
    end
  end
end
