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
#  comment_id     :bigint(8)
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Sentiment < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  enum level: {
    mixed: 'mixed',
    negative: 'negative',
    neutral: 'neutral',
    positive: 'positive',
  }

  validates :level, presence: true
end
