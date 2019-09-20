# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  provider_user_id :string
#  provider         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ApplicationRecord
  has_many :comments
  has_many :sentiments

  validates :provider, presence: true
  validates :provider_user_id, presence: true
  validates :provider_user_id, uniqueness: { scope: :provider }
end
