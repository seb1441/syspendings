class ChangeSplitToBeStringInRecords < ActiveRecord::Migration[5.1]
  def change
    change_column :records, :split, :string
  end
end
