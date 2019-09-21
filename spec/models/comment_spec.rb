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

require 'rails_helper'

RSpec.describe Comment, type: :model do

 describe 'validations' do
    it 'validates factory bot' do
      comment = FactoryBot.build :comment

      expect(comment.valid?).to be_truthy
    end

    it 'validates `text` is present' do
      comment = FactoryBot.build :comment

      comment.text = nil
      expect(comment.valid?).to be_falsey
      expect(comment.errors[:text]).to include("can't be blank")
    end

    it 'validates `commented_at` is present' do
      comment = FactoryBot.build :comment

      comment.commented_at = nil
      expect(comment.valid?).to be_falsey
      expect(comment.errors[:commented_at]).to include("can't be blank")
    end
  end

  describe 'associations' do
    let(:comment) { FactoryBot.create :comment }

    it 'belongs to a user' do
      expect(comment.user).to be_a(User)
    end

    it 'has one sentiment' do
      sentiment = FactoryBot.create :sentiment, comment: comment

      expect(comment.sentiment).to be_a(Sentiment)
    end
  end
end
