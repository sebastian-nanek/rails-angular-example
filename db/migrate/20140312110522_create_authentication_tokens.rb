class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.integer  :user_id, null: false
      t.string   :auth_token, null: false, length: 32
      t.datetime :expires_at, null: false
    end
  end
end
