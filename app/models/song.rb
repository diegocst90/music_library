class Song < ActiveRecord::Base
  attr_accessible :duration, :n_album, :name, :rating
  belongs_to :album
  
  validates :name, :presence=>true
  validates :n_album, :presence=>true
  validates :duration, :presence=>true
  validates :album, :presence=>true
end
