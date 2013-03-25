class Genre < ActiveRecord::Base
  include Core::BaseModel
  
  attr_accessible :description, :name
  has_many :albums
  
  validates :name, :presence=>true, :uniqueness=>{:case_sensitive=> false}
  
  default_scope where :deleted=>false
end
