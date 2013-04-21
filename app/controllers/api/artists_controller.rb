class Api::ArtistsController < ApplicationController
  respond_to :json
  
  def index
    respond_with Artist.all
  end
  
  def show
    opts = {:include=>[]}
    opts[:include] << :albums if params[:albums].present?
    artist = Artist.find(params[:id], opts) rescue nil
    opts[:status] = 422 if !artist
    respond_with artist, opts
  end

  def create
    artist = Artist.new(params[:artist])
    if artist.save
      render :json=>artist
    else
      respond_with artist
    end
  end

  def update
    artist = Artist.find(params[:id]) rescue nil
    if artist.blank?
      render :json=>artist, :status=>422
    else
      artist.attributes = params[:artist]
      if artist.save
        render :json=>artist
      else
        respond_with artist, :status=>422
      end
    end
  end

  def destroy
    opts = {:nothing=>true}
    opts[:status] = 422 if !Artist.delete(params[:id])
    render opts
  end
end
