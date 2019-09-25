require 'rails_helper'

RSpec.describe SlackChannelReaderJob, type: :job do
  let(:channel) { '123' }
  let(:slack_response_status) { 200 }
  let(:slack_response_body) do
    {
      "ok"=>true,
      "latest"=>"1569110399.000000",
      "oldest"=>"1568505600.000000",
      "messages"=>[
        {
          "client_msg_id"=>"a01a9164-2f21-4670-9e41-44be821a875b",
          "type"=>"message",
          "text"=>"I need help!",
          "user"=>"UN818T0D7",
          "ts"=>"1568815259.000900",
          "team"=>"TNG968U4F"
        }
      ],
      "has_more"=>false,
      "pin_count"=>0
    }.to_json
  end

  before(:each) do
    stub_slack_request(slack_response_status, slack_response_body)
  end

  it 'executes the job' do
    expect do
      SlackChannelReaderJob.perform_now(channel)
    end.to change { User.count }.from(0).to(1)
      .and change { Message.count }.from(0).to(1)
  end

  context 'when slack API returns error' do
    let(:slack_response_status) { 400 }

    it 'raises RuntimeError and aborts the job' do
      expect do
        SlackChannelReaderJob.perform_now(channel)
      end.to raise_error(RuntimeError, /invalid response status/)
        .and change { User.count }.by(0)
        .and change { Message.count }.by(0)
    end
  end

  def stub_slack_request(status, body)
    stub_request(:get, /slack.com/).to_return(
      status: status,
      body: body
    )
  end
end
