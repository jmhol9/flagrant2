class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.string :name, null: false
      t.integer :tournament_id, null: false
      t.integer :dependent_round_id
      t.datetime :picks_start, null: false
      t.datetime :picks_start, null: false
      t.timestamps
    end

    add_index :rounds, :tournament_id
    add_index :rounds, :dependent_round_id
  end
end
