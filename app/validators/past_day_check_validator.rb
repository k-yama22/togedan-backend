class PastDayCheckValidator < ActiveModel::Validator
    def validate(record)
      today = Date.today;
      if today > record.event_date
        record.errors.add :res_message , '過去日は登録できません'
      end
    end
  end