require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

token = ENV["telegrambot_token"]

p time = Time.now.strftime("%d/%m/%y")

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if !User.exists?(telegram_id: message.from.id)
      user = User.create(telegram_id: message.from.id, name: message.from.first_name)
    else
      user = User.find_by(telegram_id: message.from.id)
    end


    case message.text
    when "/start"
      bot.api.send_message(chat_id: message.chat.id, text: "hi, type /add for start")
    when "/add"
      user.act = "add"
      user.save
      bot.api.send_message(chat_id: message.chat.id, text: "send me your birthday like dd/mm/yyyy")
    when "/who@hbty_bot"
      user.act = "who"
    end

    case user.act
    when "add"
      user.act = "birthday"
      user.save
    when "birthday"
      if !Birthday.exists?(telegram_id: message.from.id)
        user.birthdays.create(telegram_id: message.from.id)
      else
        user.birthdays.find_by(telegram_id: message.from.id)
      end
      new_hb = user.birthdays.last
      new_hb.birthday = message.text
      new_hb.save
      bot.api.send_message(chat_id: message.chat.id, text: "we save your birthday")
      user.act = nil
      user.save
    when "who"
      #logic output
      birthdays = Birthday.where("birthday LIKE ?", "%#{time[0..-4]}%")
      # p Birthday.where("birthday LIKE ?", "%#{time[0..-4]}%")
      # p Birthday.where("DATE(date_first_payment) >= ?", Date.today - 1.day)
      # p Birthday.where(birthday: Date.today.beginning_of_day..Date.today.end_of_day)
      # p Birthday.where("DATE(created_at) = ?", Date.today).count
      #bot.api.send_message(chat_id: message.chat.id, text: "Happy Birthday")
      if !birthdays.size.zero?
        birthdays.each do |s_hb|
          if s_hb.telegram_id == user.telegram_id
            bot.api.send_message(chat_id: message.chat.id, text: "Happy Birthday #{user.name}")
          else
            bot.api.send_message(chat_id: message.chat.id, text: "smth wrong")
          end
        end
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Sorry, we can't find birthday boy")
      end
      user.act = nil
      user.save
    end
  end
end