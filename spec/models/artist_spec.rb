require 'spec_helper'

describe Artist do
  
  #Inspection to see if the object was saved (Generic @wrong_artist used or you can pass the specific object as parameter)
  def should_not_be_saved(wrong_artist = @wrong_artist)
    expect(wrong_artist.id).to eq(nil)
  end
  
  def should_be_saved(wrong_artist = @wrong_artist)
    expect(wrong_artist.id).not_to eq(nil)
  end
  
  describe "Validations" do
    it "shouldn't be saved without an name" do
      @wrong_artist = Artist.create()
      should_not_be_saved
      
      @wrong_artist = Artist.create(name: "Demo genre")
      should_be_saved
    end
  end
end
