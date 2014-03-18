class AddIndexOnAuthToken < ActiveRecord::Migration
  def change
    add_index :authentication_tokens, :user_id
    add_index :authentication_tokens, :auth_token
  end
end
