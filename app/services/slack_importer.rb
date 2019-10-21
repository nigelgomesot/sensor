class SlackImporter

  attr_reader :args, :messages

  def initialize(args)
    @args = args
    @messages = []
  end

  def execute!
    read_messages!
    write_messages if !messages.empty?

    messages.length
  end

  private

    def read_messages!
      reader = SlackReader.new(args)
      begin
        reader.execute!
        @messages = reader.messages
      rescue => err
        Rails.logger.fatal("SlachReader Error: #{err.message}")
        raise err
      end
    end

    def write_messages
      writer = SlackWriter.new(@messages)
      writer.execute
    end
end
