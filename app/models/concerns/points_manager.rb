class PointsManager

  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def post!(points)
    REDIS.incrby(user_point_key, points)
  end

  # def up_vote!
  #   REDIS.incrby(user_point_key, points)
  # end

  # def remove_up_vote!
  #   REDIS.decrby(user_point_key, points)
  # end

  # def down_vote!
  #   REDIS.incrby(user_point_key, points)
  # end

  # def remove_down_vote!
  #   REDIS.decrby(user_point_key, points)
  # end

  # def remove_post!
  #   REDIS.decrby(user_point_key, points)
  # end


  def points_count
     REDIS.get(user_point_key).to_i
  end

   def user_point_key
    "user:#{user.id}:points"
  end

end