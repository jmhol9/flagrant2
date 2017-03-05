class AddAllowanceToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :allowance, :float
  end
end
