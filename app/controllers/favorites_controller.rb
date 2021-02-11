class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  
  def index
    @photos = Photo.joins(:favorites).where(favorites: { user_id: params[:user_id] })
  end
  
  def create
    current_user.favorites.create(photo_id: params[:photo_id])
    
    photo = Photo.find(params[:photo_id])
    photo.create_notification_favorite!(current_user)
    
    redirect_to [:photo, { id: params[:photo_id] }]
  end
  
  def destroy
    current_user.favorites.find_by(photo_id: params[:photo_id]).destroy
    
    redirect_to [:photo, { id: params[:photo_id] }]
  end
end
