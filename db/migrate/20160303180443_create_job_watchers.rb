class CreateJobWatchers < ActiveRecord::Migration
  def change
    create_table :job_watchers do |t|
      t.boolean :completed, null: false, default: false

      t.timestamps null: false
    end
  end
end
