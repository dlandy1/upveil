class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :title, length: {minimum: 3}, presence: true
  validates :link, :format => URI::regexp(%w(http https))
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :user, presence: true
  validates :category, presence: true
end
