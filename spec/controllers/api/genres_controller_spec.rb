require 'spec_helper'

describe Api::GenresController do
  include SharedMethods
  
  #Convert a Genre object to json. Used by get_list_json_format
  def convert_to_json(genre)
    {"created_at"=>genre.created_at.to_json.gsub("\"",""), "deleted"=>false, "description"=>genre.description, "id"=>genre.id, "name"=>genre.name, "updated_at"=>genre.updated_at.to_json.gsub("\"","")}
  end
  
  describe "REST functions" do
    
    #GET :index
    it "should return all Genres" do
      @genre1 = Genre.create(name: "Demo genre1", :description=>"Description1")
      @genre2 = Genre.create(name: "Demo genre2", :description=>"Description2")
      @genre3 = Genre.create(name: "Demo genre3", :description=>"Description3")
      @genre4 = Genre.create(name: "Demo genre4", :description=>"Description4")
      
      xhr :get, :index
      expect_good_request
      expect_json(:eq, get_list_json_format([@genre1, @genre2, @genre3, @genre4]))
    end
   
    it "should return an empty array if there isn't any genre registered" do
      xhr :get, :index
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the genre given by ID" do
      @genre = Genre.create(name: "Demo genre", description: "Description")
      
      xhr :get, :show, :id=>@genre.id
      expect_good_request
      expect_json(:eq, convert_to_json(@genre))
    end
    
    it "should return a 422 error if the genre can't be found" do
      xhr :get, :show, :id=>1
      expect_bad_request
    end
    
    #POST :create
    
    it "should not save a genre if all data is incorrect" do
      xhr :post, :create, :genre => {:name=>''}
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should not save a duplicated genre" do
      @genre = Genre.create!(name: "Demo genre1", description: "Description1")
      
      ["Demo genre1","DEMO GENRE1"].each do |duplicated_name|
        xhr :post, :create, :genre => {:name=>duplicated_name, description: "Description1"}
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should save an genre if all data is correct" do
      xhr :post, :create, :genre => {:name=>'Genre name', description: "Description"}
      expect_good_request
    end
    
    #PUT :update
    it "should not update an genre if it doesn't exist" do
      xhr :put, :update, :id=>1, :genre => {:name=>"New name", description: "Description"}
      expect_bad_request
    end
    
    it "should not update an genre if all data is incorrect" do
      @genre1 = Genre.create(name: "Demo genre1")
      @genre2 = Genre.create(name: "Demo genre2")
      
      xhr :put, :update, :id=>@genre2.id, :genre => {:name=>"Demo genre1", description: "Description"}
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('activerecord.errors.messages.taken')]
          }
        })
    end
    
    it "should not updated to a duplicated genre" do
      @genre1 = Genre.create!(name: "Demo genre1")
      @genre2 = Genre.create!(name: "Demo genre2")
      
      ["Demo genre2", "DEMO GENRE2"].each do |duplicated_name|
        xhr :put, :update, :id=>@genre1.id, :genre => {:name=>duplicated_name, description: "Description"}
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should update an genre if all data is correct" do
      @genre = Genre.create(name: "Demo genre")
      
      xhr :put, :update, :id=>@genre.id, :genre => {:name=>"Updated name", description: "Description"}
      expect_good_request
      expect_json(:include, {
          "name"=>"Updated name"
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent genre" do
      xhr :delete, :destroy, :id=>1
      expect_bad_request
    end
    
    it "should delete a valid genre passed by ID" do
      @genre = Genre.create(name: "Demo genre", description: "Description")
      
      xhr :delete, :destroy, :id=>@genre.id
      expect_good_request
    end
  end
end
