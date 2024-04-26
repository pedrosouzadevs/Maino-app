# config/initializers/redis.rb
require 'redis'

# Configura a conexão Redis
$redis = Redis.new(url: ENV["redis://localhost:6379/0"])
