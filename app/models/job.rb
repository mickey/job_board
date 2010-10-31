class Job
  include MongoMapper::Document
  
  key :is_moderated,  Boolean, :default => false, :required => true
  key :source,        String, :required => true
  
  key :title,         String, :required => true
  key :date,          DateTime, :required => true
  key :description,   String, :required => true
  key :url,           String
  key :tags,          Array
  key :schedule,      String
  key :category,      String
  
  one :company
  one :address
  key :tag_ids,       Array, :required => false 
  many :tags, :in => :tag_ids
  
  attr_accessor :add_tag
  
  def tags=(tags)
    self.tag_ids = []
    tags.each do |t|
      find_tag = Tag.find_by_name(t)
      if find_tag.blank?
        final_tag = Tag.new({:name => t})
      else
        final_tag = find_tag
      end
      self.tags << final_tag
    end
  end
  
end