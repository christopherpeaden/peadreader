class CreateItemizations < ActiveRecord::Migration[5.0]
  def change
    create_table :itemizations do |t|
      t.integer :category_id
      t.integer :item_id

      t.timestamps null: false
    end
  end
end
