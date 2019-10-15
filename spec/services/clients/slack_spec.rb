require 'rails_helper'

RSpec.describe Clients::Slack, type: :service do
  let(:slack_client) { Clients::Slack.new }

  describe '#get_conversations_history' do
    let(:args) do
      {
        channel: '123',
        oldest_timestamp: Time.current.to_i,
        latest_timestamp: Time.current.to_i,
      }
    end

    it 'fetches conversation history for channel' do
      stub_request(:get, /slack.com/).to_return(
        status: 200,
        body: conversation_history_body
      )
      response = slack_client.get_conversations_history(args)

      expect(response.code).to eq(200)
      expect(response.body).to eq(conversation_history_body)
    end

    def conversation_history_body
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
            },
            {
              "client_msg_id"=>"83ccb386-9e32-4d2f-9a98-e27f5daaddea",
              "type"=>"message",
              "text"=>"I love this app.",
              "user"=>"UN818T0D7",
              "ts"=>"1568815246.000600",
              "team"=>"TNG968U4F"
            },
          ],
        "has_more"=>false,
        "pin_count"=>0
      }.to_json
    end
  end
end