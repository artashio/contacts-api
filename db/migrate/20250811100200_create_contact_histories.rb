class CreateContactHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_histories do |t|
      t.integer :contact_id, null: false
      t.text :diff, null: false
      t.timestamps
    end
    add_foreign_key :contact_histories, :contacts
  end
end
