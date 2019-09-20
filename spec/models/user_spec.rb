# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  provider_user_id :string
#  provider         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it 'validates `provider` is present' do
      user = User.new

      expect(user.valid?).to be_falsey
      expect(user.errors[:provider]).to include("can't be blank")

      user.provider = 'provider'
      user.valid?

      expect(user.errors[:provider]).to be_empty
    end

    it 'validates `provider_user_id` is present' do
      user = User.new(provider: 'provider')

      expect(user.valid?).to be_falsey
      expect(user.errors[:provider_user_id]).to include("can't be blank")

      user.provider_user_id = 'provider_user_id'
      user.valid?

      expect(user.errors[:provider_user_id]).to be_empty
    end

    it 'validates `provider_user_id` is unique per provider' do
      another_user = FactoryBot.create :user

      user = User.new
      user.provider = another_user.provider
      user.provider_user_id = another_user.provider_user_id

      expect(user.valid?).to be_falsey
      expect(user.errors[:provider_user_id]).to include("has already been taken")

      user = User.new
      user.provider = 'provider'
      user.provider_user_id = another_user.provider_user_id

      expect(user.valid?).to be_truthy
    end
  end

  describe 'associations' do
    let(:user) { FactoryBot.create :user }

    it 'has many comments' do
      comment1 = FactoryBot.create :comment, user: user
      comment2 = FactoryBot.create :comment, user: user

      expect(user.reload.comments).to match_array([comment1, comment2])
    end

    it 'has many sentiments' do
      sentiment1 = FactoryBot.create :sentiment, user: user
      sentiment2 = FactoryBot.create :sentiment, user: user

      expect(user.reload.sentiments).to match_array([sentiment1, sentiment2])
    end
  end
end
