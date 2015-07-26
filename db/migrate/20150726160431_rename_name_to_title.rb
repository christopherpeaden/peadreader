class RenameNameToTitle < ActiveRecord::Migration
  def up
   rename_column :feeds, :name, :title 
  end

  def down
    rename_column :feeds, :title, :name
  end
end
