class EntityDetector
  MESSAGES_MAX_LENGTH = 25

  attr_reader :message_ids, :messages, :entities, :aws_client

  def initialize(message_ids)
    @message_ids = message_ids
    @messages = []
    @entities = []
    set_aws_client
  end

  def execute!
    detect_entities!
    create_entities
  end

  private

    def detect_entities!
      if message_ids.empty? || message_ids.length > MESSAGES_MAX_LENGTH
        error_message = "number of messages expected: 1 to #{MESSAGES_MAX_LENGTH}"
        Rails.logger.fatal(error_message)

        raise error_message
      end

      @messages = Message.where(id: @message_ids)

      text_list = messages.map(&:text)
      response = aws_client.batch_detect_entities(text_list)

      if response['error_list'].present?
        response['error_list'].each do |error|
          message = @messages[(error['index'])]
          message_id = message.id
          code = error['error_code']
          message = error['error_message']
          error_message = "detect entities error for message_id: #{message_id}, code: #{code}, message: #{message}"
          Rails.logger.error(error_message)
        end

        raise "AWS error"
      end

      @entities = response['result_list']
      if @entities && @entities.empty?
        message = "result is empty"
        Rails.logger.fatal(message)

        raise message
      end
    end

    def create_entities
      @entities.each do |entity_group|
        message = @messages[(entity_group['index'])]
        create_entities_for_message(entity_group.entities, message)
      end
    end

    def create_entities_for_message(message_entities, message)
      message_entities.each do |entity_detail|
        begin
          create_entity!(entity_detail, message)
        rescue => err
          error_message = "create entity error: message##{message.id}, #{err.message}"

          Rails.logger.error(error_message)
        end
      end
    end

    def create_entity!(entity_detail, message)
      Entity.create! do |e|
        e.message = message
        e.user = message.user
        e.category = entity_detail['type'].downcase
        e.score = entity_detail['score']
        e.text = entity_detail['text']
      end
    end

    def set_aws_client
      comprehend_client = Aws::Comprehend::Client.new
      @aws_client = Clients::Aws.new(comprehend_client)
    end
end

__END__

ed = EntityDetector.new(Message.order(created_at: :desc).limit(1).pluck(:id))
ed.execute!
