class Comment < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

   validates :body, length: {minimum: 5}, presence: true
   validates :user, presence: true

   default_scope { order('updated_at DESC') }
end