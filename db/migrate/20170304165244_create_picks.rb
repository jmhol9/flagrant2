class CreatePicks < ActiveRecord::Migration[5.0]
  def change
    create_table :picks do |t|
      t.integer :team_id, null: false
      t.integer :entry_id, null: false
      t.integer :round_id, null: false
      t.float :points, null: false
      t.timestamps
    end

    add_index :picks, :team_id
    add_index :picks, :entry_id
    add_index :picks, :round_id
  end
end
