class Album < ActiveRecord::Base
  attr_accessible :image_url, :name, :year
  belongs_to :genre
  belongs_to :artist
  has_many :songs
  
  validates :name, :presence=>true
  validates :year, :presence=>true
  validates :genre, :presence=>true
  validates :artist, :presence=>true
end
