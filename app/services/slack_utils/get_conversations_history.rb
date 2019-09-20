module SlackUtils
  class GetConversationsHistory
    API_URL = 'https://slack.com/api/conversations.history'.freeze

    def initialize(channel, oldest_timestamp, latest_timestamp)
      @channel          = channel
      @oldest_timestamp = oldest_timestamp
      @latest_timestamp = latest_timestamp
    end

    def call
      headers = {
        'Content-type' => 'application/json'
      }

      params = {
          token:  ENV['SLACK_ACCESS_TOKEN'],
        channel:  @channel,
         oldest:  @oldest_timestamp,
         latest:  @latest_timestamp,
      }

      uri = URI("#{API_URL}?#{params.to_query}")

      JSON.parse(Net::HTTP.get(uri, nil, headers))
    end
  end
end

__END__

    def converstions_list
      headers = {
        'Content-type' => 'application/json'
      }
      token = ENV['SLACK_ACCESS_TOKEN']
      uri = URI("https://slack.com/api/conversations.list?token=#{token}")

      response =  JSON.parse(Net::HTTP.get(uri, nil, headers))
    end


    def converstions_history
        headers = {
          'Content-type' => 'application/json'
        }

        query = {
          token:   ENV['SLACK_ACCESS_TOKEN'],
          channel: 'CNGCN4PC0',
          oldest:  (Time.current.beginning_of_day).to_i,
          latest:  (Time.current.end_of_day).to_i,
        }
        uri = URI("https://slack.com/api/conversations.history?#{query.to_query}")

        response = JSON.parse(Net::HTTP.get(uri, nil, headers))
      end

 channel       = args[:channel] || 'CNGCN4PC0'
      from_datetime = args[:from_datetime] || Time.current.beginning_of_day
      upto_datetime = args[:upto_datetime] || Time.current.end_of_day 