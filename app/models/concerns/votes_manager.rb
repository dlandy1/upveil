class VotesManager

  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def up_vote!
    REDIS.multi do
       REDIS.incr product_vote_key
       REDIS.sadd product_up_voters_key, user.id
    end
    true
  end

  def down_vote!
    REDIS.multi do
      REDIS.decr product_vote_key
      REDIS.sadd product_down_voters_key, user.id
    end
    true
  end

  def remove_up_vote!
    REDIS.multi do
      REDIS.decr product_vote_key
      REDIS.srem product_up_voters_key, user.id
    end
    true
  end

  def remove_down_vote!
    REDIS.multi do
      REDIS.incr product_vote_key
      REDIS.srem product_down_voters_key, user.id
    end
    true
  end

  def already_up_voted?
    REDIS.sismember product_up_voters_key, user.id
  end

  def already_down_voted?
     REDIS.sismember product_down_voters_key, user.id
  end

  def votes_count
     REDIS.get(product_vote_key).to_i
  end

  def product_vote_key
    "product:#{product.id}:votes"
  end

  def product_up_voters_key
    "product:#{product.id}:up_voters"
  end

  def product_down_voters_key
    "product:#{product.id}:down_voters"
  end

end