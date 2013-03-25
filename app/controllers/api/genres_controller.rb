class Api::GenresController < ApplicationController
  respond_to :json
  
  def index
    respond_with Genre.all
  end
  
  def show
    genre = Genre.find(params[:id]) rescue nil
    opts = {}
    opts[:status] = 422 if !genre
    respond_with genre, opts
  end

  def create
    genre = Genre.new(params[:genre])
    if genre.save
      render :json=>genre
    else
      respond_with genre
    end
  end

  def update
    genre = Genre.find(params[:id]) rescue nil
    if genre.blank?
      render :json=>genre, :status=>422
    else
      genre.attributes = params[:genre]
      if genre.save
        render :json=>genre
      else
        respond_with genre, :status=>422
      end
    end
  end

  def destroy
    opts = {:nothing=>true}
    opts[:status] = 422 if !Genre.delete(params[:id])
    render opts
  end
end
