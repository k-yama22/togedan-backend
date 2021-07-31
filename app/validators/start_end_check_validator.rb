class StartEndCheckValidator < ActiveModel::Validator
    def validate(record)
      if record.start_time.strftime('%H:%M') > record.end_time.strftime('%H:%M')
        record.errors.add :res_message , '開始時刻より前の時刻が終了時刻に設定されています'
      end
    end
  end