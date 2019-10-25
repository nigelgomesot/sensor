require 'rails_helper'

RSpec.describe SlackImporterJob, type: :job do
  let(:args) do
    {
      channel_id: 'CNGCN4PC0',
      from_datetime: Time.current.beginning_of_day.iso8601,
      upto_datetime: Time.current.end_of_day.iso8601
    }
  end

  it 'executes the job' do
    expect do
        VCR.use_cassette('slack/conversations_history') do
          SlackImporterJob.perform_now(args)
        end
    end.to change { User.count }.from(0).to(1)
      .and change { Message.count }.from(0).to(10)
  end

  context 'when slack API returns error' do

    it 'raises RuntimeError and aborts the job' do
      expect do
        VCR.use_cassette('slack/channel_not_found') do
          SlackImporterJob.perform_now(args)
        end
      end.to raise_error(Slack::Web::Api::Errors::SlackError, /channel_not_found/)
        .and change { User.count }.by(0)
        .and change { Message.count }.by(0)
    end
  end
end
