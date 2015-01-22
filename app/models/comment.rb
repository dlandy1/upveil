class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  validates :product, presence: true
  validates :body, presence: true

end
