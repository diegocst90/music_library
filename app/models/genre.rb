class Genre < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :albums
  
  validates :name, :presence=>true
end
