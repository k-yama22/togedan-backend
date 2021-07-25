class DoubleCheckValidator < ActiveModel::Validator
    def validate(record)
      @check_event = Event.where('event_date = ? and end_time > ? and ? > start_time', record.event_date, record.start_time.strftime('%H:%M'), record.end_time.strftime('%H:%M'))
      @thisEvent = Event.find_by(id: record.id)
      if !@thisEvent || !(record.event_date == @thisEvent.event_date && record.start_time.strftime('%H:%M') == @thisEvent.start_time.strftime('%H:%M') && record.end_time.strftime('%H:%M') == @thisEvent.end_time.strftime('%H:%M'))
        if !@check_event.blank?
          record.errors.add :res_message , '既に登録済みのイベントと時間が重なっているため登録できません'
        end
      end
    end
  end