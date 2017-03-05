class AddPicksCloseToRounds < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :picks_close, :datetime, null: false
  end
end
