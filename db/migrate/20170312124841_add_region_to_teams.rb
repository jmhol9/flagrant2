class AddRegionToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :region, :string, null: false
  end
end
