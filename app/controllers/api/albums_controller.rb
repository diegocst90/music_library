class Api::AlbumsController < ApplicationController
  respond_to :json
  
  def index
    respond_with Album.where(:artist_id=>params[:artist_id])
  end
  
  def show
    respond_with Album.find(params[:id])
  end
  
  def create
    respond_with Album.create(params[:album])
  end

  def update
    respond_with Album.update(params[:id], params[:album])
  end

  def destroy
    respond_with Album.destroy(params[:id])
  end
end
