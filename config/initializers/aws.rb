credentials = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'], 
  ENV['AWS_SECRET_ACCESS_KEY']
)

options = {
  region: 'us-west-2',
  credentials: credentials
}

Aws.config.update(options)