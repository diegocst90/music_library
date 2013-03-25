class Album < ActiveRecord::Base
  include Core::BaseModel
  
  attr_accessible :image_url, :name, :year, :artist, :artist_id, :genre, :genre_id
  belongs_to :genre
  belongs_to :artist
  has_many :songs
  
  validates :name, :presence=>true, :uniqueness=>{:scope=>:artist_id, :case_sensitive=>false}
  validates :year, :presence=>true, :numericality=>{:greater_than=>1930}
  validates :genre, :presence=>true
  validates :artist, :presence=>true
  
  default_scope where :deleted=>false
end
