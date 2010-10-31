class Address
  include MongoMapper::Document
  include Geokit::Geocoders
  
  key :origin,    String
  key :city,      String
  key :country,   String
  key :loc,       Array, :index => true

  ensure_index 'address.loc'
  
  belongs_to :job
  
  before_save :geocode
  
  def geocode
    geo = MultiGeocoder.geocode(self.origin)
    if geo.success
      self.city = geo.city
      self.country = geo.country
      self.loc = [geo.lat, geo.lng]
    end
    return true
  end
end