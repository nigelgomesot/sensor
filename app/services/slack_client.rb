require 'httparty'

class SlackClient
  include HTTParty

  base_uri 'https://slack.com'

  def get_conversations_history(channel:, oldest_timestamp:, latest_timestamp:)
    options = {}

    options[:query] = {
      token:    ENV['SLACK_ACCESS_TOKEN'],
      channel:  channel,
      oldest:   oldest_timestamp,
      latest:   latest_timestamp,
    }
    options[:headers] = {
        'Content-type' => 'application/json'
      }
    path = '/api/conversations.history'

    self.class.get(path, options)
  end
end

__END__

slack_client = SlackClient.new
args = {
  channel: 'CNGCN4PC0',
  oldest_timestamp: (Time.current - 10.day).to_i,
  latest_timestamp: Time.current.to_i
}
response=slack_client.get_conversations_history(args)

# fetch channels list
def get_converstions_list
  options = {}

  options[:query] = {
    token: ENV['SLACK_ACCESS_TOKEN']
  }
  options[:headers] = {
    'Content-type' => 'application/json'
  }
  path = '/api/conversations.list'

  self.class.get(path, options)
end
