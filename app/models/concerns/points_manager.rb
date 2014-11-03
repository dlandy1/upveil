class PointsManager

  attr_reader :user, :category, :product

  def initialize(user, category, product)
    @user = user
    @category = category
    @product = product
  end

  def post!
    REDIS.multi do
       REDIS.incrby(user_point_key, 100)
       REDIS.zadd cat_point_key, 0, category.id
       REDIS.zincrby cat_point_key, 100, category.id
     end
    true
  end

  def remove_post!
    REDIS.multi do
      REDIS.decrby(user_point_key, 100)
      REDIS.zdecrby cat_point_key, 100, category.id
     end
    true
  end


  def points_count
     REDIS.get(user_point_key).to_i
  end

  def cat_points_count
    REDIS.get(cat_point_key).to_i
  end

   def user_point_key
    "user:#{user.id}:points"
  end

  def cat_point_key
    "user:#{user.id}:cat_points"
  end

end