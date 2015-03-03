require 'file_size_validator' 
require 'open-uri'
class Product < ActiveRecord::Base
  include AlgoliaSearch
  include PublicActivity::Common
   
   algoliasearch do
    hitsPerPage 40
    end

  belongs_to :user
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category", :foreign_key => "subcat_id"
  belongs_to :grandcategory, :class_name => "Category", :foreign_key => "grandcat_id"
  has_many :comments, dependent: :destroy
    mount_uploader :image, ImageUploader
      validates :image, 
    :presence => true, 
    :file_size => { 
      :minimum => 0.015.megabytes.to_i, 
      :maximum => 10.0.megabytes.to_i 
    } 

  validates :title, length: {minimum: 3, maximum: 100}, presence: true
  validates :link, :format => URI::regexp(%w(http https))
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }, presence: true
  validates :user, presence: true
  validates :category, presence: true
  validates :description,length: {minimum: 3, maximum: 300}, :allow_blank => true
  validates :subcat_id, presence: true, :if => :subcategory_present?
  validates :gender, presence: true, :if => :in_gender?


  HIGHSCORE_LB.page_size = 10

  def client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TW_KEY']
        config.consumer_secret     = ENV['TW_PASS']
        config.access_token        = ENV['TW_TOKEN']
        config.access_token_secret = ENV['TW_SECRET']
      end
  end

  def twoot
    uri = URI.parse(self.image.url)
    media = uri.open
    media.instance_eval("def original_filename; '#{File.basename(uri.path)}'; end")
    client.update_with_media("Check out the #{self.title} on www.upveil.com/categories/#{self.category.slug}/products/#{self.slug} ##{self.category.title}", media)
  end

  def price=(num)
     numb = num.to_s
    if !numb.blank?
     self[:price] = numb.scan(/\b-?[\d.]+/).join.to_f.ceil
   end
  end

   extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

    def in_gender?
      if category
      category.gendered
      end
    end

    def subcategory_present?
      if category
      category.subcategories.first
    end
    end

    def already_up_voted_by_user?(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.already_up_voted?
    end

    def already_upvote(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      PublicActivity::Activity.where(trackable_id: self.id).where(owner_id: voting_user.id).each do |p|
        p.destroy
      end
      vote_manager.remove_up_vote!
      self.category.increase_grade(self.user, -20)
      if subcategory
        subcategory = Category.friendly.find(self.subcat_id)
        subcategory.increase_grade(self.user, -20)
      end
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
      if subcategory
        subcategory = Category.friendly.find(self.subcat_id)
        subcategory.increase_grade(self.user, 15)
      end
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score - 1)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score + 15)
    end

    def up_votes
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    def points
      vote_manager = VotesManager.new(nil, self)
      vote_manager.votes_count
    end

    def down_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.down_vote!
      self.category.increase_grade(self.user, -15)
      if subcategory
        subcategory = Category.friendly.find(self.subcat_id)
        subcategory.increase_grade(self.user, -15)
       end
       current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + 1)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score - 15)
    end

    def up_vote!(voting_user)
      vote_manager = VotesManager.new(voting_user, self)
      vote_manager.up_vote!
      self.category.increase_grade(self.user, 20)
      if subcategory
        subcategory = Category.friendly.find(self.subcat_id)
        subcategory.increase_grade(self.user, 20)
      end
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + 3)
      product_score = HIGHSCORE_LB.score_for(self.user.id).to_i
      HIGHSCORE_LB.rank_member(self.user.id, product_score + 20)
      if self.tweet != true
        if self.points.to_i == 10
           self.twoot
           self.update_attributes(tweet: true)
        end
      end
    end

    def increase(voting_user, points)
      current_score = HIGHSCORE_LB.score_for(voting_user.id).to_i
      HIGHSCORE_LB.rank_member(voting_user.id, current_score + points)
    end

    algoliasearch do
    # associated index settings can be configured from here
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

     seconds = ((self.created_at.to_i - 1134028003)/30).to_f
 
     new_rank = (order + sign.to_f * seconds / 45000).round(7)
 
     update_attribute(:rank, new_rank)
   end

    def save_with_initial_vote
      ActiveRecord::Base.transaction do 
        self.save 
        self.up_votes
      end
    end
end
