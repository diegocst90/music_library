require 'spec_helper'

describe Genre do
  include SharedMethods
  
  #Inspection to see if the object was saved (Generic @wrong_genre used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_genre = @wrong_genre)
    expect(wrong_genre.id).to eq(nil)
  end
  
  def should_be_saved(wrong_genre = @wrong_genre)
    expect(wrong_genre.id).not_to eq(nil)
  end
  
  #There should be an error if the name already exists
  def should_be_wrong_duplicated_name(wrong_genre = @wrong_genre)
    validate_column_errors(wrong_genre, :name, false, 'activerecord.errors.messages.taken')
  end
  
  describe "Validations" do
    it "shouldn't be saved without an name" do
      @wrong_genre = Genre.create()
      should_not_be_saved
      
      @wrong_genre = FactoryGirl.build(:genre)
      @wrong_genre.save
      should_be_saved
    end
    
    it "should validate duplicated artists" do
      @wrong_genre = FactoryGirl.build(:genre, :defined_name)
      @wrong_genre.save
      should_be_saved
      
      @wrong_genre = FactoryGirl.build(:genre, :defined_name)
      @wrong_genre.save
      should_be_wrong_duplicated_name
    end
  end
end
