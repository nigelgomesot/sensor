require 'rails_helper'

RSpec.describe SlackImporter, type: :service do
  let(:args) do
    {
      channel_id: 'CNGCN4PC0',
      from_datetime: Time.current.beginning_of_day.iso8601,
      upto_datetime: Time.current.end_of_day.iso8601
    }
  end

  describe '#initialize' do
    it 'assigns attributes' do
      importer = SlackImporter.new(args)

      expect(importer.args).to eq(args)
      expect(importer.messages).to be_empty
    end
  end

  describe '#execute!' do
    let(:importer) { SlackImporter.new(args) }

    it 'imports messages' do
      expect do
        VCR.use_cassette('slack/conversations_history') do
          importer.execute!
        end
      end.to change { User.count }.from(0).to(1)
        .and change { Message.count }.from(0).to(10)

      expect(importer.messages.length).to_not be_zero
    end

    context 'when slack api returns error' do
      it 'raises an error and does not import messages' do
        expect do
          VCR.use_cassette('slack/channel_not_found') do
            importer.execute!
          end
        end.to raise_error(Slack::Web::Api::Errors::SlackError, /channel_not_found/)
          .and change { User.count }.by(0)
          .and change { Message.count }.by(0)

        expect(importer.messages.length).to be_zero
      end
    end
  end
end
