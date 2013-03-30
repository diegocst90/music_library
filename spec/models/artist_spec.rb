require 'spec_helper'

describe Artist do
  
  #Inspection to see if the object was saved (Generic @wrong_artist used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_artist = @wrong_artist)
    expect(wrong_artist.id).to eq(nil)
  end
  
  def should_be_saved(wrong_artist = @wrong_artist)
    expect(wrong_artist.id).not_to eq(nil)
  end
  
  #There should be an error if the name already exists
  def should_be_wrong_duplicated_name(wrong_artist = @wrong_artist)
    expect((wrong_artist.errors.get :name).to_a).to include(I18n.t('activerecord.errors.messages.taken'))
  end
  
  describe "Validations" do
    it "shouldn't be saved without an name" do
      @wrong_artist = Artist.create()
      should_not_be_saved
      
      @wrong_artist = Artist.create(name: "Demo genre")
      should_be_saved
    end
    
    it "should validate duplicated artists" do
      @wrong_artist = Artist.create(name: "Artist1")
      should_be_saved
      
      @wrong_artist = Artist.create(name: "Artist1")
      should_be_wrong_duplicated_name
    end
  end
end
