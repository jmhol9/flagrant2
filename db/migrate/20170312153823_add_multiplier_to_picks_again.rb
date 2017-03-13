class AddMultiplierToPicksAgain < ActiveRecord::Migration[5.0]
  def change
    remove_column :picks, :mulitplier
    add_column :picks, :multiplier, :integer, null: false
  end
end
