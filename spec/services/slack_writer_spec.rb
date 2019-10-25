require 'rails_helper'

RSpec.describe SlackWriter, type: :service do
  let(:provider_message_uid) { 'a01a9164-2f21-4670-9e41-44be821a875b' }
  let(:text) { 'sample text' }
  let(:provider) { 'slack' }
  let(:provider_user_uid) { 'UN818T0D7' }
  let(:args) do
    [
      {
        "client_msg_id"=>provider_message_uid,
        "type"=>"message",
        "text"=>text,
        "user"=>provider_user_uid,
        "ts"=>"1568815259.000900",
        "team"=>"TNG968U4F"
      }
    ]
  end

  describe '#initialize' do
    it 'assigns attributes' do
      slack_writer = SlackWriter.new(args)

      expected_messages = args
      expect(slack_writer.messages).to match_array(expected_messages)
    end
  end

  describe '#execute' do
    let(:slack_writer) { SlackWriter.new(args) }

    context 'adding users' do
      it 'creates a new user' do
        expect do
          slack_writer.execute
        end.to change { User.count }.from(0).to(1)

        user = User.last
        expect(user.provider).to eq(provider)
        expect(user.provider_user_uid).to eq(provider_user_uid)
      end

      it 'fetches an existing user' do
        FactoryBot.create(:user, provider_user_uid: provider_user_uid)

        expect do
          slack_writer.execute
        end.to_not change { User.count }

        user = User.last
        expect(user.provider).to eq(provider)
        expect(user.provider_user_uid).to eq(provider_user_uid)
      end
    end

    context 'adding messages' do
      let(:user) { FactoryBot.create(:user, provider_user_uid: provider_user_uid) }

      it 'creates a new message' do
        expect do
          slack_writer.execute
        end.to change { Message.count }.from(0).to(1)

        message = Message.last
        expect(message.provider_message_uid).to eq(provider_message_uid)
        expect(message.text).to eq(text)
      end

      it 'fetches an existing message' do
        FactoryBot.create(:message, provider_message_uid: provider_message_uid, user: user, text: text)

        expect do
          slack_writer.execute
        end.to_not change { Message.count }

        message = Message.last
        expect(message.provider_message_uid).to eq(provider_message_uid)
        expect(message.text).to eq(text)
      end
    end
  end
end
