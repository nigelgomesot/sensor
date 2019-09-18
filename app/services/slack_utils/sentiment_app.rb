module SlackUtils
  class SentimentApp

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

  end
end