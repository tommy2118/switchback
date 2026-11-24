class CreateTrails < ActiveRecord::Migration[8.1]
  def change
    create_table :trails do |t|
      t.string :name
      t.decimal :miles
      t.integer :gain_feet
      t.string :difficulty

      t.timestamps
    end
  end
end
