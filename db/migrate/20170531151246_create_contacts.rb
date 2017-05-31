class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id, null: false
      t.string :contacted_id, null: false
      t.integer :new_message, default: 0

      t.timestamps null: false
    end

    add_index :contacts, [:user_id, :contacted_id], unique: true
  end
end
