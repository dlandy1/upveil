class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy

  validates :title, length: {minimum: 3}, presence: true
end
