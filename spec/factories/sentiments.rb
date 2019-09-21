# == Schema Information
#
# Table name: sentiments
#
#  id             :bigint(8)        not null, primary key
#  level          :text
#  mixed_score    :float
#  negative_score :float
#  neutral_score  :float
#  positive_score :float
#  message_id     :bigint(8)
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :sentiment do
    level { "positive" }
    message
    user
  end
end
