require 'file_size_validator' 
class Product < ActiveRecord::Base
  has_many :comments, dependent: :destroy
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
   default_scope { order('rank DESC') }


    def already_up_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_up_voted?
    end

    def already_down_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_down_voted?
    end

    def up_votes
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    def down_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.down_vote!
      # points_manager = PointsManager.new(voting_user, self)
      # points_manager.down_vote!
    end

    def up_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.up_vote!
      # points_manager = PointsManager.new(voting_user, self)
      # points_manager.up_vote!
    end

    def remove_up_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_up_vote!
      # points_manager = PointsManager.new(voting_user, self)
      # points_manager.remove_up_vote!
    end

    def remove_down_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.remove_down_vote!
      # points_manager = PointsManager.new(voting_user, self)
      # points_manager.remove_up_vote!
    end

    def points
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    # s = points
    # order = log10(max(abs(s), 1))
    # if s > 0:
    #     sign = 1
    # elif s < 0:
    #     sign = -1
    # else:
    #     sign = 0
    # seconds = date - 1134028003
    # return round(sign * order + seconds / 45000, 7)

    #  s = self.points
    # order = log10(max(abs(s), 1))
    # if s > 0
    #     sign = 1
    # elsif s < 0
    #     sign = -1
    # else
    #     sign = 0
    #   end
    # seconds = (created_at - Time.new(1970,1,1))
    # new_rank =  round(sign * order + seconds / 45000, 7)

    def update_rank
     age = (created_at - Time.new(1970,1,1)) / (60 * 60 * 24) # 1 day in seconds
     new_rank = self.points + age
 
     update_attribute(:rank, new_rank)
   end

    def save_with_initial_vote
      ActiveRecord::Base.transaction do 
        self.save 
        self.up_votes
      end
    end
end
