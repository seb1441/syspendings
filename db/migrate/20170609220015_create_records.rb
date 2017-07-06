class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.date :date
      t.string :who
      t.string :description
      t.boolean :split
      t.decimal :price, :precision => 8, :scale => 2
      t.text :comment

      t.timestamps
    end
  end
end
