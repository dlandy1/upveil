class Category < ActiveRecord::Base
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  has_many :products, dependent: :destroy
  has_many :subproducts, :class_name => 'Product', :foreign_key => "subcat_id"

  belongs_to :parent_category, :class_name => "Category"
  validates :title, length: {minimum: 3}, presence: true


  scope :parent_categories, -> { where(parent_id: nil)}
  scope :sub_categories, -> {where("parent_id IS NOT NULL")}
  def to_s
    title
  end
end
