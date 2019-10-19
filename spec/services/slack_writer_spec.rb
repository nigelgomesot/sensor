require 'rails_helper'

RSpec.describe SlackWriter, type: :service do
  let(:args) do
    [
      {
        "client_msg_id"=>"a01a9164-2f21-4670-9e41-44be821a875b",
        "type"=>"message",
        "text"=>"I need help!",
        "user"=>"UN818T0D7",
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

  xdescribe '#execute' do
    context 'adding users' do
      it 'creates a new user' do
      end

      it 'fetches an existing user' do
      end
    end

    context 'adding messages' do
      it 'creates a new message' do
      end

      it 'fetches an existing message' do
      end
    end
  end
end
