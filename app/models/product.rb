class Product < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category", :foreign_key => "subcat_id"
    mount_uploader :image, ImageUploader

  validates :title, length: {minimum: 3}, presence: true
  validates :link, :format => URI::regexp(%w(http https))
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :user, presence: true
  validates :category, presence: true
  validates :description,length: {maximum: 140}, :allow_blank => true


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

    def save_with_initial_vote
      ActiveRecord::Base.transaction do 
        self.save 
        self.up_votes
      end
    end
end
