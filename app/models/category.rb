class Category < ActiveRecord::Base
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  has_many :products, dependent: :destroy

  belongs_to :parent_category, :class_name => "Category"

  validates :title, length: {minimum: 3}, presence: true
end
