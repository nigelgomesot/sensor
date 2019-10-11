require 'rails_helper'

RSpec.describe SlackImporter, type: :service do
  let(:channel_id) { '123' }

  describe '#initialize' do
    it 'assigns attributes' do
      from_datetime = Time.current.beginning_of_day.iso8601
      upto_datetime = Time.current.end_of_day.iso8601

      reader = SlackImporter.new(channel_id: channel_id, from_datetime: from_datetime, upto_datetime: upto_datetime)

      expected_channel = channel_id
      expect(reader.channel).to eq(expected_channel)

      expected_oldest_timestamp = DateTime.parse(from_datetime).to_i
      expect(reader.oldest_timestamp).to eq(expected_oldest_timestamp)

      expected_latest_timestamp = DateTime.parse(upto_datetime).to_i
      expect(reader.latest_timestamp).to eq(expected_latest_timestamp)
    end
  end

  describe '#execute' do
    let(:reader) { SlackImporter.new() }
    let(:slack_message) do
      {
        "client_msg_id"=>"a01a9164-2f21-4670-9e41-44be821a875b",
        "type"=>"message",
        "text"=>"I need help!",
        "user"=>"UN818T0D7",
        "ts"=>"1568815259.000900",
        "team"=>"TNG968U4F"
      }
    end

    it 'imports slack messages' do
      stub_slack_request(slack_message)

      expect do
        reader.execute!
      end.to change { Message.count }.from(0).to(1)
    end

    context 'when slack api returns error status' do
      it 'raises an error' do
        stub_request(:get, /slack.com/)
          .to_return(status: 400)

        expect do
          reader.execute!
        end.to raise_error(/invalid response status/)
          .and change { Message.count }.by(0)
      end
    end

    context 'when slack api returns error body' do
      it 'raises an error' do
        stub_request(:get, /slack.com/)
          .to_return(
            status: 200,
            body: {
              "ok"=> false
              }.to_json
          )

        expect do
          reader.execute!
        end.to raise_error(StandardError, /invalid response body/)
          .and change { Message.count }.by(0)
      end
    end

    describe 'creating users' do
      it 'creates an user for new `provider_user_uid`' do
        stub_slack_request(slack_message)

        expect do
          reader.execute!
        end.to change { User.count }.from(0).to(1)

        expected_provider_user_uid = slack_message['user']
        expect(User.last.provider_user_uid).to eq(expected_provider_user_uid)
      end

      context 'when `provider_user_uid` exist' do
        before(:each) do
          another_user = FactoryBot.create :user, provider_user_uid: slack_message['user']
        end

        it 'does not create an user' do
          stub_slack_request(slack_message)

          expect do
            reader.execute!
          end.not_to change { User.count }

          expected_provider_user_uid = slack_message['user']
          expect(User.last.provider_user_uid).to eq(expected_provider_user_uid)
        end
      end
    end

    describe 'creating messages' do
      it 'creates a message for new `provider_message_uid`' do
        stub_slack_request(slack_message)

        expect do
          reader.execute!
        end.to change { Message.count }.from(0).to(1)

        expected_provider_message_uid = slack_message['client_msg_id']
        expect(Message.last.provider_message_uid).to eq(expected_provider_message_uid)
      end

      context 'when `provider_message_uid` exist' do
        let(:user) { FactoryBot.create(:user, provider_user_uid: slack_message['user'])}

        before(:each) do
          another_message = FactoryBot.create(:message,
            user: user,
            provider_message_uid: slack_message['client_msg_id'],
          )
        end

        it 'does not create message' do
          stub_slack_request(slack_message)

          expect do
            reader.execute!
          end.not_to change { Message.count }

          expected_provider_message_uid = slack_message['client_msg_id']
          expect(Message.last.provider_message_uid).to eq(expected_provider_message_uid)
        end
      end

      context 'when `client_msg_id` is missing' do
        before(:each) do
          slack_message['client_msg_id'] = nil
        end

        it 'does not create message' do
          stub_slack_request(slack_message)

          expect do
            reader.execute!
          end.not_to change { Message.count }
        end
      end
    end

    def stub_slack_request(message)
      stub_request(:get, /slack.com/).to_return(
        status: 200,
        body: {
        "ok"=>true,
        "latest"=>"1569110399.000000",
        "oldest"=>"1568505600.000000",
        "messages"=>[
          message
          ],
        "has_more"=>false,
        "pin_count"=>0
      }.to_json
      )
    end
  end
end
