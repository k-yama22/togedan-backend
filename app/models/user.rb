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
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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

end
