class Post < ApplicationRecord
  validates :title, presence: true, length: { in: 2..120 }
  validates :body, presence: true, length: { minimum: 250 }

  belongs_to :user
  has_many :comments
end
