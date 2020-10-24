class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :telegram_id
      t.string :name
      t.string :act

      t.timestamps
    end
  end
end
