class AddEntryFeeToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :entry_fee, :integer
  end
end
