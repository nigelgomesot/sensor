require 'rails_helper'

RSpec.describe SlackReader, type: :service do
  let(:args) do
    {
      channel_id: 'CNGCN4PC0',
      from_datetime: Time.current.beginning_of_day.iso8601,
      upto_datetime: Time.current.end_of_day.iso8601
    }
  end

  describe '#initialize' do
    it 'assigns attributes' do
      slack_reader = SlackReader.new(args)

      expected_channel = args[:channel_id]
      expect(slack_reader.channel).to eq(expected_channel)

      expected_oldest_timestamp = DateTime.parse(args[:from_datetime]).to_i
      expect(slack_reader.oldest_timestamp).to eq(expected_oldest_timestamp)

      expected_latest_timestamp = DateTime.parse(args[:upto_datetime]).to_i
      expect(slack_reader.latest_timestamp).to eq(expected_latest_timestamp)

      expect(slack_reader.slack_client).to be_an_instance_of(Slack::Web::Client)

      expect(slack_reader.messages).to be_empty
    end
  end

  describe '#execute!' do
    let(:slack_reader) { SlackReader.new(args) }

    it 'returns conversations_history response' do
      VCR.use_cassette('slack/conversations_history') do
        slack_reader.execute!
        message = slack_reader.messages.first
        expect(message).to include('client_msg_id', 'type', 'text', 'user', 'ts')
      end
    end

    context 'when Slack returns errors' do
      before(:each) do
        args[:channel_id] = 'invalid'
      end

      it 'raises an error' do
        expect do
          VCR.use_cassette('slack/channel_not_found') do
            slack_reader.execute!
          end
        end.to raise_error(Slack::Web::Api::Errors::SlackError, /channel_not_found/)
      end
    end
  end
end
