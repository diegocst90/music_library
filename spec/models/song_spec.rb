require 'spec_helper'

describe Song do
  include SharedMethods
  
  #Inspection to see if the object was saved (Generic @wrong_song used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_song = @wrong_song)
    expect(wrong_song.id).to eq(nil)
  end
  
  def should_be_saved(wrong_song = @wrong_song)
    expect(wrong_song.id).not_to eq(nil)
  end
  
  #There should be an error with the duration format
  def should_be_wrong_on_duration_format(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :duration, false, 'activerecord.errors.models.song.attributes.duration.invalid_format')
  end
  
  def should_be_ok_on_duration_format(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :duration, true, 'activerecord.errors.models.song.attributes.duration.invalid_format')
  end
  
  #There should be an error if the # of song is less or equal than 0
  def should_be_wrong_on_n_album_value(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :n_album, false, 'errors.messages.greater_than', :count=>0)
  end
  
  def should_be_ok_on_n_album_value(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :n_album, true, 'errors.messages.greater_than', :count=>0)
  end
  
  #There should be an error if the rating is less than 0 or more than 5
  def should_be_less_on_rating_value(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :rating, false, 'errors.messages.less_than_or_equal_to', :count=>5)
  end
  
  def should_be_more_on_rating_value(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :rating, false, 'errors.messages.greater_than_or_equal_to', :count=>0)
  end
  
  def should_be_ok_on_rating_value(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :rating, true, 'errors.messages.greater_than_or_equal_to', :count=>0)
    validate_column_errors(wrong_song, :rating, true, 'errors.messages.less_than_or_equal_to', :count=>5)
  end
  
  #There should be an error if the name already exists
  def should_be_wrong_duplicated_name(wrong_song = @wrong_song)
    validate_column_errors(wrong_song, :name, false, 'activerecord.errors.messages.taken')
  end
  
  #Method to build 1 artist, 1 genre and 1 album
  def build_demo_data
    @album = FactoryGirl.create(:album)
  end
  
  describe "Validations" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    it "shouldn't be saved without an album, n_album, duration, rating or name" do
      @wrong_song = Song.create()
      should_not_be_saved
      
      @wrong_song = Song.create(album: @album)
      should_not_be_saved
      
      @wrong_song = Song.create(n_album: 3)
      should_not_be_saved
      
      @wrong_song = Song.create(rating: 3)
      should_not_be_saved
      
      @wrong_song = Song.create(duration: "04:40")
      should_not_be_saved
      
      @wrong_song = Song.create(name: "Demo song")
      should_not_be_saved
      
      @wrong_song = FactoryGirl.build(:song)
      @wrong_song.save
      should_be_saved
    end
    
    it "should validate # song greater than 0" do
      @wrong_song = FactoryGirl.build(:song, :wrong_n_album)
      @wrong_song.save
      should_be_wrong_on_n_album_value
      
      @wrong_song = FactoryGirl.build(:song)
      @wrong_song.save
      should_be_ok_on_n_album_value
    end
    
    it "should validate rating greater than or equal to 0 an less than or equal to 5" do
      @wrong_song = FactoryGirl.build(:song, :too_much_rating)
      @wrong_song.save
      should_be_less_on_rating_value
      
      @wrong_song = FactoryGirl.build(:song, :too_less_rating)
      @wrong_song.save
      should_be_more_on_rating_value
      
      @wrong_song = FactoryGirl.build(:song)
      @wrong_song.save
      should_be_ok_on_rating_value
    end
    
    it "should validate the format of duration: XX:XX" do
      #wrong cases
      ["Wrong","1232","03:321x","55055,h5"].each do |wrong_duration|
        @wrong_song = FactoryGirl.build(:song, duration: wrong_duration)
        @wrong_song.save
        should_be_wrong_on_duration_format
      end
      
      #correct case
      @wrong_song = FactoryGirl.build(:song)
      @wrong_song.save
      should_be_ok_on_duration_format
    end
    
    it "should validate duplicated songs of the same album" do
      FactoryGirl.create(:song, :defined_name, album_id: @album.id)
      @wrong_song = FactoryGirl.build(:song, :defined_name, album_id: @album.id)
      @wrong_song.save
      should_be_wrong_duplicated_name
      
      album2 = FactoryGirl.create(:album)
      @wrong_song = FactoryGirl.build(:song, :defined_name, album_id: album2.id)
      @wrong_song.save
      should_be_saved
    end
  end
end
