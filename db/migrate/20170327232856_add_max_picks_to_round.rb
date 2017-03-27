class AddMaxPicksToRound < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :max_picks, :integer
  end
end
