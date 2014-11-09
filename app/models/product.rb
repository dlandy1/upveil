require 'file_size_validator' 
class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category", :foreign_key => "subcat_id"
    mount_uploader :image, ImageUploader
      validates :image, 
    :presence => true, 
    :file_size => { 
      :minimum => 0.03.megabytes.to_i, 
      :maximum => 0.5.megabytes.to_i 
    } 

  validates :title, length: {minimum: 3}, presence: true
  validates :link, :format => URI::regexp(%w(http https))
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :user, presence: true
  validates :category, presence: true
  validates :description,length: {maximum: 140}, :allow_blank => true
  # if
  validates :gender, presence: true
   default_scope { order('rank DESC') }

    # Product.unscoped do
    #   @new = New.includes(:product).all
    # end


    def already_up_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_up_voted?
    end

    def already_upvote(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_up_vote!
      self.category.increase_grade(self.user, -20)
      self.category.increase_points(voting_user, -3)
    end

    def already_down_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_down_voted?
    end
     def already_downvote(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_down_vote!
      self.category.increase_grade(self.user, 15)
      self.category.increase_points(voting_user, -1)
    end

    def up_votes
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    def down_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.down_vote!
      self.category.increase_grade(self.user, -15)
      self.category.increase_points(voting_user, 1)
    end

    def up_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.up_vote!
      self.category.increase_grade(self.user, 20)
      self.category.increase_points(voting_user, 3)
    end

    def points
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end
    
    def update_rank
    s = self.points
    order = (Math.log(10)*([(s).abs, 1].max))
 
    sign = if s > 0
      1
    elsif s < 0
      -1
    else
      0
    end

     seconds = self.created_at.to_i - 1134028003
 
    new_rank = (order + sign * seconds / 45000).round
 
     update_attribute(:rank, new_rank)
   end

    def save_with_initial_vote
      ActiveRecord::Base.transaction do 
        self.save 
        self.up_votes
      end
    end
end
