require "resque-retry"
require "resque-sentry"
require "resque-timeout"
require "resque/failure/redis"
require "resque/server"

redis_url = ENV["REDISCLOUD_URL"] || ENV["OPENREDIS_URL"] || ENV["REDISGREEN_URL"] || ENV["REDISTOGO_URL"] || 'localhost:6379'
uri = URI.parse(redis_url)
Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)

Resque.after_fork do
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

Resque.before_fork do
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

Resque::Failure.backend = Resque::Failure::MultipleWithRetrySuppression

Resque::Failure::MultipleWithRetrySuppression.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Sentry,
]

Resque::Failure::Sentry.logger = "resque"

Resque::Plugins::Timeout.timeout = (ENV["RESQUE_JOB_TIMEOUT"] || 120).to_i

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ENV['RESQUE_ADMIN_PASSWORD']
end
