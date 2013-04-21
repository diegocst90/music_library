class Api::AlbumsController < ApplicationController
  respond_to :json
  
  def index
    respond_with Album.where(:artist_id=>params[:artist_id])
  end
  
  def show
    opts = {:include=>[]}
    opts[:include] << :songs if params[:songs].present?
    album = Album.find(params[:id], opts) rescue nil
    opts[:status] = 422 if !album
    respond_with album, opts
  end
  
  def create
    album = Album.new(params[:album])
    if album.save
      render :json=>album
    else
      respond_with album
    end
  end

  def update
    album = Album.find(params[:id]) rescue nil
    if album.blank?
      render :json=>album, :status=>422
    else
      album.attributes = params[:album]
      if album.save
        render :json=>album
      else
        respond_with album, :status=>422
      end
    end
  end

  def destroy
    opts = {:nothing=>true}
    opts[:status] = 422 if !Album.delete(params[:id])
    render opts
  end
end
