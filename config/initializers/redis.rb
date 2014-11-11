REDIS = Redis.new

HIGHSCORE_LB = Leaderboard.new('highscores', Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})