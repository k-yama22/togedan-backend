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
end
