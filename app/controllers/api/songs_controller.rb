class Api::SongsController < ApplicationController
  respond_to :json
  
  def index
    respond_with Song.where(:album_id=>params[:album_id])
  end
  
  def show
    song = Song.find(params[:id]) rescue nil
    opts = {}
    opts[:status] = 422 if !song
    respond_with song, opts
  end
  
  def create
    song = Song.new(params[:song])
    if song.save
      render :json=>song
    else
      respond_with song
    end
  end

  def update
    song = Song.find(params[:id]) rescue nil
    if song.blank?
      render :json=>song, :status=>422
    else
      song.attributes = params[:song]
      if song.save
        render :json=>song
      else
        respond_with song, :status=>422
      end
    end
  end

  def destroy
    opts = {:nothing=>true}
    opts[:status] = 422 if !Song.delete(params[:id])
    render opts
  end
end
