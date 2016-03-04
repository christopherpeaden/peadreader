class AddUserIdToJobWatchers < ActiveRecord::Migration
  def change
    add_reference :job_watchers, :user, index: true, foreign_key: true
  end
end
