require 'spec_helper'

describe Genre do
  
  #Inspection to see if the object was saved (Generic @wrong_genre used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_genre = @wrong_genre)
    expect(wrong_genre.id).to eq(nil)
  end
  
  def should_be_saved(wrong_genre = @wrong_genre)
    expect(wrong_genre.id).not_to eq(nil)
  end
  
  #There should be an error if the name already exists
  def should_be_wrong_duplicated_name(wrong_genre = @wrong_genre)
    expect((wrong_genre.errors.get :name).to_a).to include(I18n.t('activerecord.errors.messages.taken'))
  end
  
  describe "Validations" do
    it "shouldn't be saved without an name" do
      @wrong_genre = Genre.create()
      should_not_be_saved
      
      @wrong_genre = Genre.create(name: "Demo genre")
      should_be_saved
    end
    
    it "should validate duplicated artists" do
      @wrong_genre = Genre.create(name: "Artist1")
      should_be_saved
      
      @wrong_genre = Genre.create(name: "Artist1")
      should_be_wrong_duplicated_name
    end
  end
end
