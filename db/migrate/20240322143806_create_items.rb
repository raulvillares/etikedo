class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end

    add_index :items, [:list_id, :name], unique: true
  end
end
