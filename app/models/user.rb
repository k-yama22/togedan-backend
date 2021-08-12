# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  birthday               :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  email_check            :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  first_name_kana        :string
#  image                  :string
#  introduce              :string
#  last_name              :string
#  last_name_kana         :string
#  phone                  :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  user_name              :string
#  user_sts               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, ImageUploader
  has_many :events

  VALID_DATE_REGEX = /\A\d{4}-\d{2}-\d{2}\z/

  validates :last_name, presence: true, length: {maximum: 20}
  validates :first_name, presence: true, length: {maximum: 20}
  validates :last_name_kana, presence: true, length: {maximum: 40}, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "は全角カタカナで入力してください"}
  validates :first_name_kana, presence: true, length: {maximum: 40}, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: "は全角カタカナで入力してください"}
  validates :user_name, presence: true, length: {maximum: 20}
  validates :birthday, presence: true, format: {with: VALID_DATE_REGEX}
  validates :phone, presence: true, length: {maximum: 11}, numericality: true
  validates :introduce, length: {maximum: 255}
  validates :user_sts, presence: true, length: {is: 1}


  # イベント検索用SQL
  # 共通
  scope :events, -> {joins(:events)}
  scope :select_event, -> {select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people")}

  # 検索条件が通常の場合
  scope :where_normal, -> (genre, location) {where('genre LIKE(?) and location LIKE(?) and event_date > (?) and event_sts = ?', "%#{genre}%", "%#{location}%", Date.today, "1")}
  scope :normal, -> (genre, location) {events.select_event.where_normal(genre, location)}

  # 検索条件がevent_dateの場合
  scope :where_date, -> (genre, location, event_date) { where('genre LIKE(?) and location LIKE(?) and event_date = (?) and event_sts = ?', "%#{genre}%", "%#{location}%", "%#{event_date}%", "1") }
  scope :date, -> (genre, location, event_date) { events.select_event.where_date(genre, location, event_date) }

  # 検索条件がevent_dateかつstart_timeの場合
  scope :where_date_start, -> (genre, location, event_date, start_time) { where('genre LIKE(?) and location LIKE(?) and event_date = (?) and start_time >= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", "%#{event_date}%", "%#{start_time}%", "1") }
  scope :date_start, -> (genre, location, event_date, start_time) { events.select_event.where_date_start(genre, location, event_date, start_time) }

  # 検索条件がevent_dateかつend_timeの場合
  scope :where_date_end, -> (genre, location, event_date, end_time) { where('genre LIKE(?) and location LIKE(?) and event_date = (?) and end_time <= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", "%#{event_date}%", "%#{end_time}%", "1") }
  scope :date_end, -> (genre, location, event_date, end_time) { events.select_event.where_date_end(genre, location, event_date, end_time) }

  # 検索条件がevent_dateかつstart_timeかつend_timeの場合
  scope :where_date_start_end, -> (genre, location, event_date, start_time, end_time) { where('genre LIKE(?) and location LIKE(?) and event_date = (?) and start_time >= (?) and end_time <= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", "%#{event_date}%", "%#{start_time}%", "%#{end_time}%", "1") }
  scope :date_start_end, -> (genre, location, event_date, start_time, end_time) { events.select_event.where_date_start_end(genre, location, event_date, start_time, end_time) }

  # 検索条件がstart_timeの場合
  scope :where_start_time, -> (genre, location, start_time) { events.select_event.where('genre LIKE(?) and location LIKE(?) and event_date > (?) and start_time >= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", Date.today, "%#{start_time}%", "1") }
  scope :start_time, -> (genre, location, start_time) { events.select_event.where_start_time(genre, location, start_time) }

  # 検索条件がend_timeの場合
  scope :where_end_time, -> (genre, location, end_time) { where('genre LIKE(?) and location LIKE(?) and event_date > (?) and end_time <= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", Date.today, "%#{end_time}%", "1") }
  scope :end_time, -> (genre, location, end_time) { events.select_event.where_end_time(genre, location, end_time) }

  # 検索条件がstart_timeかつend_timeの場合
  scope :where_start_end, -> (genre, location, start_time, end_time) { where('genre LIKE(?) and location LIKE(?) and event_date > (?) and start_time >= (?) and end_time <= (?) and event_sts = ?', "%#{genre}%", "%#{location}%", Date.today, "%#{start_time}%", "%#{end_time}%", "1") }
  scope :start_end, -> (genre, location, start_time, end_time) { events.select_event.where_start_end(genre, location, start_time, end_time) }
end
