class Job
  include MongoMapper::Document
  include Search
  
  key :is_moderated,  Boolean, :default => false, :required => true
  key :source,        String, :required => true
  
  key :title,         String, :required => true
  key :date,          DateTime, :required => true
  key :description,   String, :required => true
  key :category,      String
  key :url,           String
  key :tags_list,     Array
  key :schedule,      String
  key :tag_ids,       Array, :required => false
  
  one :company
  one :address
  many :tags, :in => :tag_ids
  
  validate_on_update :category_required, :tag_required
  before_save :fill_tags
  
  attr_accessor :add_tag
  
  def fill_tags
    self.tags_list = self.tags.map(&:name)
  end
  
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
  
  def tag_required
    errors.add(:tags, "can't be blank") if is_moderated == true and tags.length < 1
  end
  
  def category_required
    errors.add(:category, "can't be blank")  if is_moderated == true and category.blank?
  end
  
end