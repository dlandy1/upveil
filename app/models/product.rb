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
end
