class PastTimeCheckValidator < ActiveModel::Validator
    def validate(record)
      today = Date.today;
      now = Time.now
      if today == record.event_date && now.strftime('%H:%M') > record.start_time.strftime('%H:%M')
        record.errors.add :res_message , '過去の時刻は登録できません'
      end
    end
  end