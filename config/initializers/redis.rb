uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

HIGHSCORE_LB = Leaderboard.new('highscores', Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})