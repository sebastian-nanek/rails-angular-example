class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.integer :user_id, :null => false
      t.text :content
      t.datetime :due_date
      t.integer :priority, :default => 1, :null => false
      t.boolean :completed, :default => false, :null => false

      t.timestamps
    end
  end
end
