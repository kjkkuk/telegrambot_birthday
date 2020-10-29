class ChangeBirthdayToBeDateInBirthdays < ActiveRecord::Migration[6.0]
  def up
    #change_column :birthdays, :birthday, "USING birthday::date"
    change_column :birthdays, :birthday, 'date USING CAST(birthday AS date)'

  end

  def down
    change_column :birthdays, :birthday, 'string USING CAST(birthday AS string)'
    #change_column :birthdays, :birthday, "USING birthday::string"
  end
end
