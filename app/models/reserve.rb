# == Schema Information
#
# Table name: reserves
#
#  id          :bigint           not null, primary key
#  reserve_sts :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :integer
#  user_id     :integer
#
class Reserve < ApplicationRecord
  validates :event_id, presence: true, length: {maximum: 10}
  validates :user_id, presence: true, length: {maximum: 10}
  validates :reserve_sts, presence: true, length: {is: 1}

end
