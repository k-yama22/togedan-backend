# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  end_time      :time
#  event_date    :date
#  event_message :text
#  event_name    :string
#  event_sts     :string
#  genre         :string
#  location      :string
#  max_people    :integer
#  start_time    :time
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :string
#
class Event < ApplicationRecord
end
