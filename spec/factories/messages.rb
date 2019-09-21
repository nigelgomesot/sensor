# == Schema Information
#
# Table name: messages
#
#  id                   :bigint(8)        not null, primary key
#  text                 :text
#  provider_message_uid :string
#  sent_at              :datetime
#  user_id              :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryBot.define do
  factory :message do
    text { "Have a nice day!" }
    provider_message_uid { FFaker::Guid.guid }
    sent_at { Time.current }
    user
  end
end
