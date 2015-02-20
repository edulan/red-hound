if ENV['REDIS_PROVIDER']
  REDIS = Redis.connect(url: ENV['REDIS_PROVIDER'])
end
