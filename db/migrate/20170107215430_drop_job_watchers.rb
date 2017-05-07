class DropJobWatchers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :job_watchers, :user, index: true, foreign_key: true
    drop_table :job_watchers do |t|
      t.boolean :completed, null: false, default: false

      t.timestamps null: false
    end
  end
end
