class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  validates :product, presence: true
  validates :body, presence: true
  has_many :subcomments, :class_name => "Comment", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_comment, :class_name => "Comment", :foreign_key => "parent_id"

  scope :parent_comments, -> { where(parent_id: nil)}
  scope :children, -> {where("parent_id IS NOT NULL")}


end
