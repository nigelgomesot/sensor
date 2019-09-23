require 'rails_helper'

RSpec.describe SlackChannelReader, type: :service do
  let(:channel_id) { '123' }

  describe '#initialize' do
    it 'assigns attributes' do
      channel = channel_id
      from_datetime = (Time.current - 1.day).beginning_of_day
      upto_datetime = (Time.current - 1.day).end_of_day

      reader = SlackChannelReader.new(channel_id, from_datetime: from_datetime, upto_datetime: upto_datetime)

      expected_channel = channel_id
      expect(reader.channel).to eq(expected_channel)

      expected_oldest_timestamp = from_datetime.to_i
      expect(reader.oldest_timestamp).to eq(expected_oldest_timestamp)

      expected_latest_timestamp = upto_datetime.to_i
      expect(reader.latest_timestamp).to eq(expected_latest_timestamp)
    end
  end

  describe '#execute' do
    let(:reader) { SlackChannelReader.new(channel_id) }
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

    it 'stores slack messages' do
      stub_slack_request(slack_message)

      expect do
        reader.execute!
      end.to change { Message.count }.from(0).to(1)
    end

    context 'when slack api returns error status' do
      it 'raises an error' do
        stub_request(:get, /slack.com/).to_return(status: 400, body: '')

        expect do
          reader.execute!
        end.to raise_error(/invalid response status/)
          .and change { Message.count }.by(0)
      end
    end

    xcontext 'when slack api returns error body' do
      it 'raises an error' do
        stub_request(:get, /slack.com/).to_return(status: 400, body: '')

        expect do
          reader.execute!
        end.to raise_error(/invalid response body/)
          .and change { Message.count }.by(0)
      end
    end

    describe 'creating users' do
      context 'when new user' do

        it 'creates an user' do
        end
      end

      context 'when existing user' do

        it 'does not create an user' do
        end
      end
    end

    describe 'creating messages' do
      context 'when new message' do

        it 'creates a message' do
        end
      end

      context 'when existing message' do

        it 'does not create message' do
        end
      end

      context 'when `client_msg_id` is missing' do

        it 'does not create message' do
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
