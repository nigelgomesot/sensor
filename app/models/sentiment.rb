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

class Sentiment < ApplicationRecord
  belongs_to :message
  belongs_to :user

  enum level: {
    positive: 'positive',
    neutral: 'neutral',
    negative: 'negative',
    mixed: 'mixed',
  }

  validates :level, presence: true

  delegate :text, to: :message
  delegate :sent_at, to: :message

  def status_tag
    case self.level
      when :positive then :ok
      when :neutral then :warning
      when :negative then :error
      when :mixed then :warning
    end
  end
end
