class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #ユーザーネームは必須入力
  validates :username, presence: true
  validates :profile, length: { maximum: 200 }
  
  # 経路1
  # uesr(user_id) → 中間テーブル → target_user(user_id)
  # 中間テーブル本体はforrow
  has_many :active_relationships, class_name: 'Follow', foreign_key: 'user_id'
  
  # 経路2
  # uesr(user_id) ← relationships ← target_user(user_id)
  # 中間テーブル本体はforrow
  has_many :passive_relationships, class_name: 'Follow', foreign_key: 'target_user_id'
  
  has_many :followings, through: :active_relationships, source: :target_user
  has_many :followers, through: :passive_relationships, source: :user
  
  has_many :comments
  has_many :favorites
  has_many :photos, dependent: :destroy
  
  #自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  #相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
end
