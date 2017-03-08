class CreateUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :updates do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    add_index :updates, :author_id
    drop_table :blogs
  end
end
