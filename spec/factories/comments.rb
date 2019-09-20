# == Schema Information
#
# Table name: comments
#
#  id           :bigint(8)        not null, primary key
#  text         :text
#  commented_at :datetime
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :comment do
    text { "MyText" }
    commented_at { "2019-09-20 11:10:40" }
    user { nil }
  end
end
