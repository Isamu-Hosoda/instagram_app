class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one_attached :image
  
  validates :image, presence: true
  
  has_many :notifications, dependent: :destroy
  
  #お気に入り通知機能の作成
  def create_notification_favorite!(current_user)
    
    #既にお気に入り登録されているか確認
    temp = Notification.where(
      ["visitor_id = ? and visited_id = ? and photo_id = ? and action = ? ",
      current_user.id, user_id, id, 'favorite']
    )
      
    #お気に入り登録されていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        photo_id:   id,
        visited_id: user_id,
        action:     'favorite'
      )
    end
    
    #自分の投稿に対するお気に入り登録の場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  #コメント通知機能の作成
  def create_notification_comment!(current_user, comment_id)
    save_notification_comment!(current_user, comment_id, user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      photo_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
