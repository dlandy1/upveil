require 'file_size_validator' 
class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category", :foreign_key => "subcat_id"
    mount_uploader :image, ImageUploader
      validates :image, 
    :presence => true, 
    :file_size => { 
      :minimum => 0.015.megabytes.to_i, 
      :maximum => 10.0.megabytes.to_i 
    } 

  validates :title, length: {minimum: 3, maximum: 40}, presence: true
  validates_uniqueness_of :title
  validates :link, :format => URI::regexp(%w(http https))
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :user, presence: true
  validates :category, presence: true
  validates :description,length: {minimum: 3, maximum: 140}, :allow_blank => true
  validates :subcat_id, presence: true
  validates :gender, :if => :in_fashion?, presence: true

  def price=(num)
    self[:price] = num.to_s.scan(/\b-?[\d.]+/).join.to_f
  end

   extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end


    def in_fashion?
      category == 'Fashion'
    end

    def already_up_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_up_voted?
    end

    def already_upvote(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_up_vote!
      self.category.increase_grade(self.user, -20)
      subcategory = Category.friendly.find(self.subcat_id)
      subcategory.increase_grade(self.user, -20)
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score - 3)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score - 20)
    end

    def already_down_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_down_voted?
    end
     def already_downvote(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_down_vote!
      self.category.increase_grade(self.user, 15)
      subcategory = Category.friendly.find(self.subcat_id)
      subcategory.increase_grade(self.user, 15)
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score - 1)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score + 15)
    end

    def up_votes
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    def down_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.down_vote!
      self.category.increase_grade(self.user, -15)
      subcategory = Category.friendly.find(self.subcat_id)
      subcategory.increase_grade(self.user, -15)
       current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + 1)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score - 15)
    end

    def up_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.up_vote!
      self.category.increase_grade(self.user, 20)
      subcategory = Category.friendly.find(self.subcat_id)
      subcategory.increase_grade(self.user, 20)
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + 3)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score + 20)
    end

    def increase(voting_user, points)
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + points)
    end

    def points
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end
    
    def update_rank
    s = self.points
    order = Math.log( [s.abs, 1].max,  10 )
 
    sign = if s > 0
      1
    elsif s < 0
      -1
    else
      0
    end

     seconds = (self.created_at.to_i - 1134028003).to_f
 
     new_rank = (order + sign.to_f) + (seconds / 45000)
 
     update_attribute(:rank, new_rank)
   end

    def save_with_initial_vote
      ActiveRecord::Base.transaction do 
        self.save 
        self.up_votes
      end
    end
end
