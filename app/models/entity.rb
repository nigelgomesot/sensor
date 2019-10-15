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

class Entity < ApplicationRecord
  belongs_to :message
  belongs_to :user

  enum category: {
    commercial_item: 'commercial_item',
    date: 'date',
    event: 'event',
    location: 'location',
    organization: 'organization',
    other: 'other',
    person: 'person',
    quantity: 'quantity',
    title: 'title',
  }

  validates :category, presence: true
  delegate :sent_at, to: :message

  def message_text
    self.message.text
  end
end
