class CreateBirthdays < ActiveRecord::Migration[6.0]
  def change
    create_table :birthdays do |t|
      t.integer :telegram_id
      t.string :birthday
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
