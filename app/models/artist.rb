class Artist < ActiveRecord::Base
  include Core::BaseModel
  
  attr_accessible :name
  has_many :albums
  
  validates :name, :presence=>true, :uniqueness=>{:case_sensitive=> false}
  
  default_scope where :deleted=>false
end
