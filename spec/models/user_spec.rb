# == Schema Information
#
# Table name: users
#
#  id                :bigint(8)        not null, primary key
#  provider          :string
#  provider_user_uid :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it 'validates factory bot' do
      user = FactoryBot.build :user

      expect(user.valid?).to be_truthy
    end

    it 'validates `provider` is present' do
      user = FactoryBot.build :user

      user.provider = nil
      expect(user.valid?).to be_falsey
      expect(user.errors[:provider]).to include("can't be blank")
    end

    it 'allows only specific providers' do
      user = FactoryBot.build :user

      expect do
        user.provider = 'invalid'
      end.to raise_error(ArgumentError, /is not a valid provider/)
    end

    it 'validates `provider_user_uid` is present' do
      user = FactoryBot.build :user

      user.provider_user_uid = nil
      expect(user.valid?).to be_falsey
      expect(user.errors[:provider_user_uid]).to include("can't be blank")
    end

    it 'validates `provider_user_uid` is unique per provider' do
      another_user = FactoryBot.create :user

      user = FactoryBot.build :user
      user.provider_user_uid = another_user.provider_user_uid

      expect(user.valid?).to be_falsey
      expect(user.errors[:provider_user_uid]).to include("has already been taken")
    end
  end

  describe 'associations' do
    let(:user) { FactoryBot.create :user }

    it 'has many messages' do
      message1 = FactoryBot.create :message, user: user
      message2 = FactoryBot.create :message, user: user

      expect(user.reload.messages).to match_array([message1, message2])
    end

    it 'has many sentiments' do
      sentiment1 = FactoryBot.create :sentiment, user: user
      sentiment2 = FactoryBot.create :sentiment, user: user

      expect(user.reload.sentiments).to match_array([sentiment1, sentiment2])
    end
  end
end
