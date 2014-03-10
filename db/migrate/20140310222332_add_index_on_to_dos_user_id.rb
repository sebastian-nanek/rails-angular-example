class AddIndexOnToDosUserId < ActiveRecord::Migration
  def change
    add_index :to_dos, :user_id
  end
end
