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
    it 'validates `text` is present' do
      comment = Comment.new

      expect(comment.valid?).to be_falsey
      expect(comment.errors[:text]).to include("can't be blank")

      comment.text = 'text'
      comment.valid?

      expect(comment.errors[:text]).to be_empty
    end

    it 'validates `commented_at` is present' do
      comment = Comment.new(text: 'text')

      expect(comment.valid?).to be_falsey
      expect(comment.errors[:commented_at]).to include("can't be blank")

      comment.commented_at = Time.current
      comment.valid?

      expect(comment.errors[:commented_at]).to be_empty
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
