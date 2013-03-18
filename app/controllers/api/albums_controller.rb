class Api::AlbumsController < ApplicationController
  respond_to :json
  
  def index
    respond_with Album.where(:artist_id=>params[:artist_id])
  end
  
  def show
    respond_with Artist.find(params[:id])
  end
  
  def create
    respond_with Artist.create(params[:entry])
  end

  def update
    respond_with Artist.update(params[:id], params[:entry])
  end

  def destroy
    respond_with Artist.destroy(params[:id])
  end
end
