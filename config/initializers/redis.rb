REDIS = Redis.new

HIGHSCORE_LB = Leaderboard.new('highscores', Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})
User.all.each do |u|
  HIGHSCORE_LB.rank_member(u.name, u.points_count)
end