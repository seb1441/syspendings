class ChangeDefaultValueForSplit < ActiveRecord::Migration[5.1]
  def change
    change_column_default :records, :split, true
  end
end
