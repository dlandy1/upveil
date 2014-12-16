class Category < ActiveRecord::Base
  include AlgoliaSearch
  include PublicActivity::Common

  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  has_many :products, dependent: :destroy
  has_many :subproducts, :class_name => 'Product', :foreign_key => "subcat_id"
  has_many :grandproducts, :class_name => 'Product', :foreign_key => "grandcat_id"

  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id"
  belongs_to :user
  validates :title, length: {minimum: 3}, presence: true
  validates :description, length: {minimum: 7}, :allow_blank => true


  scope :parent_categories, -> { where(parent_id: nil)}
  scope :sub_categories, -> {where("parent_id IS NOT NULL")}

  extend FriendlyId
  friendly_id :title, use: :slugged

  algoliasearch do
    hitsPerPage 40
    end

  algoliasearch index_name: "Parentcats", if: subcategories.first do
    
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def to_s
    title
  end

  def top
    a_rank = Product.where(category_id: self.id).count.to_i
    update_attribute(:rank, a_rank)
  end

  def top_b
    b_rank = Product.where(subcat_id: self.id).count.to_i
    update_attribute(:rank, b_rank)
  end

    def top_c
    c_rank = Product.where(grandcat_id: self.id).count.to_i
    update_attribute(:rank, c_rank)
  end


  def leaderboard
    @leaderboard ||= Leaderboard.new("#{self.title.downcase.gsub(" ", '')}_highscores", Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})
  end

  def score(user)
    self.leaderboard.score_for(user.id).to_i
  end

  def increase_grade(user, points)
    current_score = self.leaderboard.score_for(user.id).to_i
    self.leaderboard.rank_member(user.id, current_score + points)
    if self.parent_id
    parent = self.parent_id
    category = Category.friendly.find(parent)
    category.leaderboard.rank_member(user.id, current_score + points)
    end
  end
end