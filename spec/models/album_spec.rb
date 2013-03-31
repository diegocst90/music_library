require 'spec_helper'

describe Album do
  include SharedMethods
  
  #Inspection to see if the object was saved (Generic @wrong_album used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_album = @wrong_album)
    expect(wrong_album.id).to eq(nil)
  end
  
  def should_be_saved(wrong_album = @wrong_album)
    expect(wrong_album.id).not_to eq(nil)
  end
  
  #There should be an error if the year of the album is less or equal than 1930
  def should_be_wrong_on_year_value(wrong_album = @wrong_album)
    validate_column_errors(wrong_album, :year, false, 'errors.messages.greater_than', :count=>1930)
  end
  
  def should_be_ok_on_year_value(wrong_album = @wrong_album)
    validate_column_errors(wrong_album, :year, true, 'errors.messages.greater_than', :count=>1930)
  end
  
  #There should be an error if the name already exists
  def should_be_wrong_duplicated_name(wrong_album = @wrong_album)
    validate_column_errors(wrong_album, :name, false, 'activerecord.errors.messages.taken')
  end
  
  #Method to build 1 artist, 1 genre
  def build_demo_data
    @artist = FactoryGirl.create :artist
    @genre = FactoryGirl.create :genre
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
      
      @wrong_album = FactoryGirl.build(:album)
      @wrong_album.save
      should_be_saved
    end
    
    it "should validate album year greater than 1930" do
      @wrong_album = FactoryGirl.build(:album, :wrong_year)
      @wrong_album.save
      should_be_wrong_on_year_value
      
      @wrong_album = FactoryGirl.build(:album)
      @wrong_album.save
      should_be_ok_on_year_value
    end
    
    it "should validate duplicated albums of the same artist" do
      FactoryGirl.create(:album, :defined_name, artist_id: @artist.id)
      @wrong_album = FactoryGirl.build(:album, :defined_name, artist_id: @artist.id, genre_id: @genre.id)
      @wrong_album.save
      should_be_wrong_duplicated_name
      
      artist2 = FactoryGirl.create(:artist)
      @wrong_album = FactoryGirl.build(:album, :defined_name, artist_id: artist2.id, genre_id: @genre.id)
      @wrong_album.save
      should_be_saved
    end
  end
end
