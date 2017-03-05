class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.integer :user_id, null: false
      t.integer :tournament_id, null: false
      t.float :points, null: false
      t.timestamps
    end

    add_index :entries, :user_id
  end
end
