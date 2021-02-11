class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  
  has_many :notifications, dependent: :destroy
  
  validates :body, presence: true
end

