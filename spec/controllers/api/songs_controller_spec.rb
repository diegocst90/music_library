require 'spec_helper'

describe Api::SongsController do
  include SharedMethods
  
  #Method to build 1 song
  def build_demo_data
    @artist = FactoryGirl.create :artist
    @album = FactoryGirl.create :album, artist_id: @artist.id
  end
  
  describe "REST functions" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    #GET :index
    it "should return all songs from an Album" do
      list_songs = FactoryGirl.create_list :song, 4, album_id: @album.id
      
      xhr :get, :index, :album_id=>@album.id, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, get_list_json_format(list_songs, "song"))
    end
    
    it "should return an empty array if there isn't any song registered" do
      xhr :get, :index, :album_id=>@album.id, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the song given by ID" do
      song = FactoryGirl.create(:song, album_id: @album.id)
      
      xhr :get, :show, :id=>song.id, :album_id=>@album.id, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, convert_to_json(song, "song"))
    end
    
    it "should return a 422 error if the song can't be found" do
      xhr :get, :show, :id=>1, :album_id=>@album.id, :artist_id=>@artist.id
      expect_bad_request
    end
    
    #POST :create
    it "should not save an song if all data is incorrect" do
      xhr :post, :create, :album_id=>@album.id, :artist_id=>@artist.id, :song => FactoryGirl.attributes_for(:song, :too_much_rating, album_id: @album.id)
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "rating"=>[I18n.t('errors.messages.less_than_or_equal_to', :count=>5)]
          }
        })
    end
    
    it "should save an song if all data is correct" do
      xhr :post, :create, :album_id=>@album.id, :artist_id=>@artist.id, :song => FactoryGirl.attributes_for(:song, album_id: @album.id)
      expect_good_request
    end
    
    it "should return the json result of the song created" do
      new_attributes = FactoryGirl.attributes_for(:song, album_id: @album.id)
      xhr :post, :create, :album_id=>@album.id, :artist_id=>@artist.id, :song => new_attributes
      expect_json(:include, convert_to_json(new_attributes, "song"))
    end
    
    #PUT :update
    it "should not update an song if it doesn't exist" do
      xhr :put, :update, :album_id=>@album.id, :artist_id=>@artist.id, :id=>1, :song => FactoryGirl.attributes_for(:song, album_id: @album.id)
      expect_bad_request
    end
    
    it "should not update an song if all data is incorrect" do
      song = FactoryGirl.create(:song, album_id: @album.id)
      
      xhr :put, :update, :album_id=>@album.id, :artist_id=>@artist.id, :id=>song.id, :song => FactoryGirl.attributes_for(:song, :too_much_rating)
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "rating"=>[I18n.t('errors.messages.less_than_or_equal_to', :count=>5)]
          }
        })
    end
    
    it "should update an song if all data is correct" do
      song = FactoryGirl.create(:song, album_id: @album.id)
      new_attributes = FactoryGirl.attributes_for(:song, :defined_name)
      xhr :put, :update, :album_id=>@album.id, :artist_id=>@artist.id, :id=>song.id, :song => new_attributes
      expect_good_request
      expect_json(:include,{
          "name"=>new_attributes[:name]
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent song" do
      xhr :delete, :destroy, :id=>1, :album_id=>@album.id, :artist_id=>@artist.id
      expect_bad_request
    end
    
    it "should delete a valid song passed by ID" do
      song = FactoryGirl.create(:song, album_id: @album.id)
      
      xhr :delete, :destroy, :id=>song.id, :album_id=>@album.id, :artist_id=>@artist.id
      expect_good_request
    end
  end
end
