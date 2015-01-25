class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  validates :product, presence: true
  validates :body, presence: true
  has_many :subcomments, :class_name => "Comments", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_comment, :class_name => "Comments", :foreign_key => "parent_id"

end
