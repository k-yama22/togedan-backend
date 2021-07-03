# == Schema Information
#
# Table name: reserves
#
#  id          :bigint           not null, primary key
#  reserve_sts :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :string
#  user_id     :string
#
class Reserve < ApplicationRecord
  validates :event_id, presence: true, length: {maximum: 10}
  validates :user_id, presence: true, length: {maximum: 10}
  validates :reserve_sts, presence: true

end
