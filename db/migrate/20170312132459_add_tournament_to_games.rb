class AddTournamentToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :tournament_id, :integer, null:false
    add_index :games, :tournament_id
  end
end
