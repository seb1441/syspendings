class RemoveCommentFromRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :records, :comment, :text
  end
end
