require 'rails_helper'

RSpec.describe SlackReader, type: :service do
  let(:args) do
    {
      channel_id: 123,
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
end