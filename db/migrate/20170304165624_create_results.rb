class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.integer :round_id, null: false
      t.integer :team_id, null: false
      t.boolean :win, null: false
      t.timestamps
    end

    add_index :results, :round_id
    add_index :results, :team_id
  end
end
