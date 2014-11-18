class Category < ActiveRecord::Base
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  has_many :products, dependent: :destroy
  has_many :subproducts, :class_name => 'Product', :foreign_key => "subcat_id"

  belongs_to :parent_category, :class_name => "Category"
  validates :title, length: {minimum: 3}, presence: true


  scope :parent_categories, -> { where(parent_id: nil)}
  scope :sub_categories, -> {where("parent_id IS NOT NULL")}

   self.leaderboard.page_size = 10

  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def to_s
    title
  end

  def leaderboard
    @leaderboard ||= Leaderboard.new("#{self.title.downcase.gsub(" ", '')}_highscores", Leaderboard::DEFAULT_OPTIONS, {:redis_connection => REDIS})
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