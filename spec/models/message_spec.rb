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

require 'rails_helper'

RSpec.describe Message, type: :model do

 describe 'validations' do
    it 'validates factory bot' do
      message = FactoryBot.build :message

      expect(message.valid?).to be_truthy
    end

    it 'validates `text` is present' do
      message = FactoryBot.build :message

      message.text = nil
      expect(message.valid?).to be_falsey
      expect(message.errors[:text]).to include("can't be blank")
    end

    it 'validates `provider_message_uid` is present' do
      message = FactoryBot.build :message

      message.provider_message_uid = nil
      expect(message.valid?).to be_falsey
      expect(message.errors[:provider_message_uid]).to include("can't be blank")
    end

    it 'validates `provider_message_uid` is unique per user' do
      another_message = FactoryBot.create :message

      message = FactoryBot.build :message
      message.user = another_message.user
      message.provider_message_uid = another_message.provider_message_uid

      expect(message.valid?).to be_falsey
      expect(message.errors[:provider_message_uid]).to include("has already been taken")
    end

    it 'validates `sent_at` is present' do
      message = FactoryBot.build :message

      message.sent_at = nil
      expect(message.valid?).to be_falsey
      expect(message.errors[:sent_at]).to include("can't be blank")
    end
  end

  describe 'associations' do
    let(:message) { FactoryBot.create :message }

    it 'belongs to a user' do
      expect(message.user).to be_a(User)
    end

    it 'has one sentiment' do
      sentiment = FactoryBot.create :sentiment, message: message

      expect(message.sentiment).to be_a(Sentiment)
    end
  end
end
