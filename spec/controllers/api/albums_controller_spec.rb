require 'spec_helper'

describe Api::AlbumsController do
  include SharedMethods
  
  #Convert an Album object to json. Used by get_list_json_format
  def convert_to_json(album)
    {"artist_id"=>album.artist_id, "created_at"=>album.created_at.to_json.gsub("\"",""), "deleted"=>false, "genre_id"=>album.genre_id, "id"=>album.id, "image_url"=>nil, "name"=>album.name, "updated_at"=>album.updated_at.to_json.gsub("\"",""), "year"=>album.year}
  end
  
  #Method to build 1 artist, 1 genre
  def build_demo_data
    @artist = Artist.create!(name: "Demo artist")
    @genre = Genre.create!(name: "Demo genre")
  end
  
  describe "REST functions" do
    
    #Before all tests, we populate data
    before do
      build_demo_data
    end
    
    #GET :index
    it "should return all albums from an Artist" do
      @album1 = Album.create(name: "Demo album1", year: 2006, genre: @genre, artist: @artist)
      @album2 = Album.create(name: "Demo album2", year: 2008, genre: @genre, artist: @artist)
      @album3 = Album.create(name: "Demo album3", year: 2010, genre: @genre, artist: @artist)
      @album4 = Album.create(name: "Demo album4", year: 2012, genre: @genre, artist: @artist)
      
      get :index, :artist_id=>@artist.id, :format => :json
      expect_good_request
      expect_json(:eq, get_list_json_format([@album1, @album2, @album3, @album4]))
    end
    
    it "should return an empty array if there isn't any album registered" do
      get :index, :artist_id=>@artist.id, :format => :json
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the album given by ID" do
      @album = Album.create(name: "Demo album1", year: 2006, genre: @genre, artist: @artist)
      
      get :show, :id=>@album.id, :artist_id=>@artist.id, :format => :json
      expect_good_request
      expect_json(:eq, convert_to_json(@album))
    end
    
    it "should return a 422 error if the album can't be found" do
      get :show, :id=>1, :artist_id=>@artist.id, :format => :json
      expect_bad_request
    end
    
    #POST :create
    it "should not save an album if all data is incorrect" do
      post :create, :artist_id=>@artist.id, :album => {:year=>2000, :genre_id=>@genre.id}, :format => :json
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')],
            "artist"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should not save a duplicated album" do
      @artist2 = Artist.create!(name: "Demo artist2")
      @album = Album.create(name: "Album name", year: 2006, genre: @genre, artist: @artist)
      
      #Same artist, we should not allow it
      ["Album name", "ALBUM NAME"].each do |duplicated_name|
        post :create, :artist_id=>@artist.id, :album => {:name=>duplicated_name, :year=>2000, :artist_id=>@artist.id, :genre_id=>@genre.id}, :format => :json
        expect_bad_request
        expect_json(:include,{
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
      #Another artist should be allowed
      post :create, :artist_id=>@artist2.id, :album => {:name=>"Album name", :year=>2000, :artist_id=>@artist2.id, :genre_id=>@genre.id}, :format => :json
      expect_good_request
    end
    
    it "should save an album if all data is correct" do
      post :create, :artist_id=>@artist.id, :album => {:name=>'Album name', :year=>2000, :artist_id=>@artist.id, :genre_id=>@genre.id}, :format => :json
      expect_good_request
    end
    
    #PUT :update
    it "should not update an album if it doesn't exist" do
      put :update, :artist_id=>@artist.id, :id=>1, :album => {:year=>2000}, :format => :json
      expect_bad_request
    end
    
    it "should not update an album if all data is incorrect" do
      @album = Album.create(name: "Demo album", year: 2006, genre: @genre, artist: @artist)
      
      put :update, :artist_id=>@artist.id, :id=>@album.id, :album => {:year=>1901}, :format => :json
      expect_bad_request
      expect_json(:include,{
          "errors"=>{
            "year"=>[I18n.t('errors.messages.greater_than', :count=>1930)]
          }
        })
    end
    
    it "should not update to a duplicated album of the same artist" do
      @artist2 = Artist.create!(name: "Demo artist2")
      @album1 = Album.create(name: "Album name1", year: 2006, genre: @genre, artist: @artist)
      @album2 = Album.create(name: "Album name2", year: 2006, genre: @genre, artist: @artist)
      
      ["Album name1", "ALBUM NAME1"].each do |duplicated_name|
        put :update, :artist_id=>@artist.id, :id=>@album2.id, :album => {:name=>duplicated_name}, :format => :json
        expect_bad_request
        expect_json(:include,{
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
      
      #Another artist should be allowed
      @album3 = Album.create(name: "Album name3", year: 2006, genre: @genre, artist: @artist2)
      
      put :update, :artist_id=>@artist2.id, :id=>@album3.id, :album => {:name=>"Album name1"}, :format => :json
      expect_good_request
    end
    
    it "should update an album if all data is correct" do
      @album = Album.create(name: "Demo album", year: 2006, genre: @genre, artist: @artist)
      
      put :update, :artist_id=>@artist.id, :id=>@album.id, :album => {:year=>2000}, :format => :json
      expect_good_request
      expect_json(:include,{
          "year"=>2000
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent album" do
      delete :destroy, :id=>1, :artist_id=>@artist.id, :format=> :json
      expect_bad_request
    end
    
    it "should delete a valid album passed by ID" do
      @album = Album.create(name: "Demo album", year: 2006, genre: @genre, artist: @artist)
      
      delete :destroy, :id=>@album.id, :artist_id=>@artist.id, :format=> :json
      expect_good_request
    end
  end
end
