class DoubleCheckValidator < ActiveModel::Validator
    def validate(record)
      @check_event = Event.where(event_date: record.event_date, start_time: record.start_time.strftime('%H:%M')..record.end_time.strftime('%H:%M'),end_time: record.start_time.strftime('%H:%M')..record.end_time.strftime('%H:%M'))
      if !@check_event.blank?
        record.errors.add :start_time , '既に登録済みのイベントと時間が重なっているため登録できません'
      end
    end
  end