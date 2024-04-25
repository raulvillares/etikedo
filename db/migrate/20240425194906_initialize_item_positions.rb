class InitializeItemPositions < ActiveRecord::Migration[7.1]
  def up
    unless column_exists?(:items, :position)
      raise ActiveRecord::IrreversibleMigration, "items table does not have a position column"
    end

    List.find_each do |list|
      list.items.order(created_at: :desc).each_with_index do |item, index|
        item.update(position: index + 1)
      end
    end
  end

  def down
    Item.update_all(position: nil) # rubocop:disable Rails/SkipsModelValidations
  end
end
