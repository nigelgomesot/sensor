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

FactoryBot.define do
  factory :user do
    provider { 'slack' }
    provider_user_id { FFaker::Guid.guid }
  end
end
