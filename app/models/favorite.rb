class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  
  validates :photo_id, uniqueness: { scope: :user_id }
end
