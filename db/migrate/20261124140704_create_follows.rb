class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trail, null: false, foreign_key: true

      t.timestamps
      t.index %i[ user_id trail_id ], unique: true
    end
  end
end
