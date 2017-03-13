class AddMultiplierToPicks < ActiveRecord::Migration[5.0]
  def change
    add_column :picks, :mulitplier, :integer, null: false
  end
end
