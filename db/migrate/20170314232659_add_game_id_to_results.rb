class AddGameIdToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :game_id, :integer, null: false
    remove_index :results, :round_id
    remove_column :results, :round_id
  end
end
