class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #name, usernameは必須入力
  validates :name, presence: true
  validates :username, presence: true

  #プロフィールは200文字まで
  validates :profile, length: { maximum: 200 }
  
  #ユーザーのプロフィール画像を設定
  has_one_attached :image, dependent: :destroy
  
  # 経路1
  # uesr(user_id) → 中間テーブル → target_user(user_id)
  # 中間テーブル本体はforrow
  has_many :active_relationships, class_name: 'Follow', foreign_key: 'user_id', dependent: :destroy
  
  # 経路2
  # uesr(user_id) ← relationships ← target_user(user_id)
  # 中間テーブル本体はforrow
  has_many :passive_relationships, class_name: 'Follow', foreign_key: 'target_user_id', dependent: :destroy
  
  has_many :followings, through: :active_relationships, source: :target_user, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :photos, dependent: :destroy
  
  #自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  #相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
end
