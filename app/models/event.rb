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
#  user_id       :integer
#
class Event < ApplicationRecord
  include ActiveModel::Validations
  validates_with DoubleCheckValidator
  validates_with PastDayCheckValidator
  validates_with PastTimeCheckValidator
  validates :user_id, presence: true, length: {maximum: 10}
  validates :event_name, presence: true, length: {maximum: 30}
  validates :genre, presence: true, length: {maximum: 20}
  validates :location, presence: true, length: {maximum: 20}
  validates :event_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :event_message, length: {maximum: 255}
  validates :max_people, length: {maximum: 3}
  validates :event_sts, presence: true, length: {is: 1}

  belongs_to :user
end
