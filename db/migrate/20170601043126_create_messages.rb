class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :reciver_id, null: false

      t.text :content, null: false
      t.timestamps null: false
    end

    add_index :messages, [:sender_id, :reciver_id]
  end
end
