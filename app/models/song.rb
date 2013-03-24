class Song < ActiveRecord::Base
  attr_accessible :duration, :n_album, :name, :rating, :album
  belongs_to :album
  
  validates :name, :presence=>true
  validates :n_album, :presence=>true, :numericality=>{:greater_than=>0}
  validates :duration, :presence=>true
  validates :album, :presence=>true
  
  before_save :verify_duration_format
  
  def verify_duration_format
    #Correct format for duration XX:XX
    if !(/([01]?[0-9]|2[0-3]):[0-5][0-9]/.match(duration).present? && duration.to_s.length == 5)
      errors.add(:duration, I18n.t('activerecord.errors.models.song.attributes.duration.invalid_format'))
      return false
    end
  end
end
