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

FactoryBot.define do
  factory :user do
    provider { 'slack' }
    provider_user_uid { FFaker::Guid.guid }
  end
end
