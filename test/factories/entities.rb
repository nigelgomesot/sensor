# == Schema Information
#
# Table name: entities
#
#  id         :bigint(8)        not null, primary key
#  message_id :bigint(8)
#  user_id    :bigint(8)
#  category   :string
#  score      :decimal(, )
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :entity do
    message { nil }
    user { nil }
    category { "MyString" }
    score { "9.99" }
    text { "MyString" }
  end
end
