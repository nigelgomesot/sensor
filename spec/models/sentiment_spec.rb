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

require 'rails_helper'

RSpec.describe Sentiment, type: :model do

  describe 'validations' do
    it 'validates `level` is present' do
      sentiment = Sentiment.new

      expect(sentiment.valid?).to be_falsey
      expect(sentiment.errors[:level]).to include("can't be blank")

      sentiment.level = 'positive'
      sentiment.valid?

      expect(sentiment.errors[:level]).to be_empty
    end

    it 'allows only specific levels' do
      sentiment = Sentiment.new

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

    it 'belongs to a comment' do
      expect(sentiment.comment).to be_a(Comment)
    end
  end
end
