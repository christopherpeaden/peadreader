class DropJobwatchers < ActiveRecord::Migration[5.0]
  def change
    drop_table :jobwatchers do |t|
      t.boolean :completed, null: false, default: false

      t.timestamps null: false
    end
  end
end
