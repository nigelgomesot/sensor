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

require 'rails_helper'

RSpec.describe Sentiment, type: :model do

  describe 'validations' do
    it 'validates factory bot' do
      sentiment = FactoryBot.build :sentiment

      expect(sentiment.valid?).to be_truthy
    end

    it 'validates `level` is present' do
      sentiment = FactoryBot.build :sentiment

      sentiment.level = nil
      expect(sentiment.valid?).to be_falsey
      expect(sentiment.errors[:level]).to include("can't be blank")
    end

    it 'allows only specific levels' do
      sentiment = FactoryBot.build :sentiment

      expect do
        sentiment.level = 'invalid'
      end.to raise_error(ArgumentError, /is not a valid level/)
    end
  end

  describe 'associations' do
    let(:sentiment) { FactoryBot.create :sentiment }

    it 'belongs to a user' do
      expect(sentiment.user).to be_a(User)
    end

    it 'belongs to a message' do
      expect(sentiment.message).to be_a(Message)
    end
  end
end
