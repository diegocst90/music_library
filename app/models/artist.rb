class Artist < ActiveRecord::Base
  attr_accessible :name
  has_many :albums
  
  validates :name, :presence=>true
end
