class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.time :published
      t.references :feed, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
