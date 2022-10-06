class Post < ApplicationRecord
  validates :title, presence: true, length: { in: 2..120 }
  validates :body, presence: true

  belongs_to :user
end
