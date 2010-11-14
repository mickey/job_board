class Address
  include MongoMapper::EmbeddedDocument
  include Geokit::Geocoders
  
  key :origin,        String
  key :city,          String
  key :country,       String
  key :country_code,  String
  key :loc,           Array
  key :zip,           String
  key :state,         String
  key :anywhere,      Boolean, :default => false
  
  belongs_to :job
  
  before_save :geocode
  
  def geocode
    if Address.is_anywhere?(self.origin)
      self.anywhere = true
      return true 
    end
    geo = MultiGeocoder.geocode(self.origin)
    if geo.success
      self.city = geo.city
      self.country = geo.country
      self.country_code = geo.country_code
      self.zip = geo.zip
      self.state = geo.state
      self.loc = [geo.lat, geo.lng]
    end
    return true
  end
  
  def self.is_anywhere?(addr)
    !(addr =~ /(anywhere|tellecommuting|telecommute|remote|distant|anyplace)/i).nil?
  end
  
end