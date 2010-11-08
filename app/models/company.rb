class Company
  include MongoMapper::Document
  
  key :name,      String, :required => true
  key :url,       String

  key :image_uid, String   # dragonfly stuff
  image_accessor :image
  
  belongs_to :job
end