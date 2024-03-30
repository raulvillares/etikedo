class AddUserToLists < ActiveRecord::Migration[7.1]
  def change
    add_reference :lists, :user, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end
