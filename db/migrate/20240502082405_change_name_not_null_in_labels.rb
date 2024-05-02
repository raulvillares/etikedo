class ChangeNameNotNullInLabels < ActiveRecord::Migration[7.1]
  def change
    change_column_null :labels, :name, false
  end
end
