REDIS = Redis.new

HIGHSCORE_LB = Leaderboard.new('highscores', Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})
redis_options = {:redis_connection => REDIS}
CATEGORY_HIGHSCORE_LB = Leaderboard.new('other_highscores', Leaderboard::DEFAULT_OPTIONS, redis_options)
User.all.each do |u|
  HIGHSCORE_LB.rank_member(u.name, u.points_count)
  # CATEGORY_HIGHSCORE_LB.rank_member(u.name, u.cat_points_count(Category.find(1).id))
end