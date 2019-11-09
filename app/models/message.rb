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

class Message < ApplicationRecord
  belongs_to :user
  has_one :sentiment, dependent: :destroy
  has_many :entities, dependent: :delete_all

  validates :text, presence: true
  validates :provider_message_uid, presence: true
  validates :provider_message_uid, uniqueness: { scope: :user }
  validates :sent_at, presence: true

  scope :sent_at_date, ->(date) do
    where("sent_at >= ? and sent_at <= ?", date.beginning_of_day, date.end_of_day)
  end
  scope :positive, -> { joins(:sentiment).merge(Sentiment.positive) }
  scope :negative, -> { joins(:sentiment).merge(Sentiment.negative) }
end
