# == Schema Information
#
# Table name: users
#
#  id                :bigint(8)        not null, primary key
#  provider          :string
#  provider_user_uid :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ApplicationRecord
  has_many :messages, dependent: :delete_all
  has_many :sentiments, dependent: :delete_all
  has_many :entities, dependent: :delete_all

  enum provider: {
    slack: 'slack',
  }

  validates :provider, presence: true
  validates :provider_user_uid, presence: true
  validates :provider_user_uid, uniqueness: { scope: :provider }
end
