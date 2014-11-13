uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:3000/" )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

HIGHSCORE_LB = Leaderboard.new('highscores', Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})