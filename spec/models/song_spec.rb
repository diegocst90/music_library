require 'spec_helper'

describe Song do
  
  #Inspection to see if the object was saved (Generic @wrong_song used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_song = @wrong_song)
    expect(wrong_song.id).to eq(nil)
  end
  
  def should_be_saved(wrong_song = @wrong_song)
    expect(wrong_song.id).not_to eq(nil)
  end
  
  #There should be an error with the duration format
  def should_be_wrong_on_duration_format(wrong_song = @wrong_song)
    expect((wrong_song.errors.get :duration).to_a).to include(I18n.t('activerecord.errors.models.song.attributes.duration.invalid_format'))
  end
  
  def should_be_ok_on_duration_format(wrong_song = @wrong_song)
    expect((wrong_song.errors.get :duration).to_a).not_to include(I18n.t('activerecord.errors.models.song.attributes.duration.invalid_format'))
  end
  
  #Method to build 1 artist, 1 genre and 1 album
  def build_demo_data
    @artist = Artist.create!(name: "Demo artist")
    @genre = Genre.create!(name: "Demo genre")
    @album = Album.create(name: "Demo album", year: "2006", genre: @genre, artist: @artist)
  end
  
  describe "Validations" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    it "shouldn't be saved without an album, n_album, duration or name" do
      @wrong_song = Song.create()
      should_not_be_saved
      
      @wrong_song = Song.create(album: @album)
      should_not_be_saved
      
      @wrong_song = Song.create(n_album: 3)
      should_not_be_saved
      
      @wrong_song = Song.create(duration: "04:40")
      should_not_be_saved
      
      @wrong_song = Song.create(name: "Demo song")
      should_not_be_saved
      
      @wrong_song = Song.create(name: "Demo name", duration: "04:40", n_album: 3, album: @album)
      should_be_saved
    end
    
    it "should validate the format of duration: XX:XX" do
      @wrong_song = Song.create(name: "Demo name1", duration: "Wrong", n_album: 3, album: @album)
      should_be_wrong_on_duration_format
      
      @wrong_song = Song.create(name: "Demo name2", duration: "1232", n_album: 3, album: @album)
      should_be_wrong_on_duration_format
      
      @wrong_song = Song.create(name: "Demo name3", duration: "03:321x", n_album: 3, album: @album)
      should_be_wrong_on_duration_format
      
      @wrong_song = Song.create(name: "Demo name4", duration: "55055,h5", n_album: 3, album: @album)
      should_be_wrong_on_duration_format
      
      @wrong_song = Song.create(name: "Demo name5", duration: "04:40", n_album: 3, album: @album)
      should_be_ok_on_duration_format
    end
  end
end
