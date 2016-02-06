class AddAccessTokenExpirationToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token_expiration, :integer
  end
end
