require 'spec_helper'

describe Api::AlbumsController do
  include SharedMethods
  
  #Method to build 1 artist, 1 genre
  def build_demo_data
    @artist = FactoryGirl.create :artist
    @genre = FactoryGirl.create :genre
  end
  
  describe "REST functions" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    #GET :index
    it "should return all albums from an Artist" do
      list_albums = FactoryGirl.create_list :album, 4, artist_id: @artist.id
      
      xhr :get, :index, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, get_list_json_format(list_albums, "albums"))
    end
    
    it "should return an empty array if there isn't any album registered" do
      xhr :get, :index, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the album given by ID" do
      album = FactoryGirl.create(:album, artist_id: @artist.id)
      
      xhr :get, :show, :id=>album.id, :artist_id=>@artist.id
      expect_good_request
      expect_json(:eq, convert_to_json(album, "album"))
    end
    
    it "should return a 422 error if the album can't be found" do
      xhr :get, :show, :id=>1, :artist_id=>@artist.id
      expect_bad_request
    end
    
    #POST :create
    it "should not save an album if all data is incorrect" do
      xhr :post, :create, :artist_id=>@artist.id, :album => {:year=>2000, :genre_id=>@genre.id}
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')],
            "artist"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should save an album if all data is correct" do
      xhr :post, :create, :artist_id=>@artist.id, :album => FactoryGirl.attributes_for(:album, artist_id: @artist.id, genre_id: @genre.id)
      expect_good_request
    end
    
    it "should return the json result of the album created" do
      new_attributes = FactoryGirl.attributes_for(:album, artist_id: @artist.id, genre_id: @genre.id)
      xhr :post, :create, :artist_id=>@artist.id, :album => new_attributes
      expect_json(:include, convert_to_json(new_attributes, "album"))
    end
    
    #PUT :update
    it "should not update an album if it doesn't exist" do
      xhr :put, :update, :artist_id=>@artist.id, :id=>1, :album => FactoryGirl.attributes_for(:album, artist_id: @artist.id)
      expect_bad_request
    end
    
    it "should not update an album if all data is incorrect" do
      album = FactoryGirl.create(:album, artist_id: @artist.id)
      
      xhr :put, :update, :artist_id=>@artist.id, :id=>album.id, :album => {:year=>1901}
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "year"=>[I18n.t('errors.messages.greater_than', :count=>1930)]
          }
        })
    end
    
    it "should update an album if all data is correct" do
      album = FactoryGirl.create(:album, artist_id: @artist.id)
      new_attributes = FactoryGirl.attributes_for(:artist, :defined_name)
      xhr :put, :update, :artist_id=>@artist.id, :id=>album.id, :album => new_attributes
      expect_good_request
      expect_json(:include,{
          "name"=>new_attributes[:name]
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent album" do
      xhr :delete, :destroy, :id=>1, :artist_id=>@artist.id, :format=> :json
      expect_bad_request
    end
    
    it "should delete a valid album passed by ID" do
      album = FactoryGirl.create(:album, artist_id: @artist.id)
      
      xhr :delete, :destroy, :id=>album.id, :artist_id=>@artist.id, :format=> :json
      expect_good_request
    end
  end
end
