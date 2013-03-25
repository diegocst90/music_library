require 'spec_helper'

describe Album do
  
  #Inspection to see if the object was saved (Generic @wrong_album used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_album = @wrong_album)
    expect(wrong_album.id).to eq(nil)
  end
  
  def should_be_saved(wrong_album = @wrong_album)
    expect(wrong_album.id).not_to eq(nil)
  end
  
  #There should be an error if the year of the album is less or equal than 1930
  def should_be_wrong_on_year_value(wrong_album = @wrong_album)
    expect((wrong_album.errors.get :year).to_a).to include(I18n.t('errors.messages.greater_than', :count=>1930))
  end
  
  def should_be_ok_on_year_value(wrong_album = @wrong_album)
    expect((wrong_album.errors.get :year).to_a).not_to include(I18n.t('errors.messages.greater_than', :count=>1930))
  end
  
  #Method to build 1 artist, 1 genre
  def build_demo_data
    @artist = Artist.create!(name: "Demo artist")
    @genre = Genre.create!(name: "Demo genre")
  end
  
  describe "Validations" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    it "shouldn't be saved without an artist, genre, name or year" do
      @wrong_album = Album.create()
      should_not_be_saved
      
      @wrong_album = Album.create(artist: @artist)
      should_not_be_saved
      
      @wrong_album = Album.create(genre: @genre)
      should_not_be_saved
      
      @wrong_album = Album.create(name: "Demo name")
      should_not_be_saved
      
      @wrong_album = Album.create(year: 2006)
      should_not_be_saved
      
      @wrong_album = Album.create(name: "Demo album", year: 2006, genre: @genre, artist: @artist)
      should_be_saved
    end
    
    it "should validate album year greater than 1930" do
      @wrong_album = Album.create(name: "Less than 1930", year: 1920, genre: @genre, artist: @artist)
      should_be_wrong_on_year_value
      
      @wrong_album = Album.create(name: "Greater than 1930", year: 2006, genre: @genre, artist: @artist)
      should_be_ok_on_year_value
    end
  end
end
