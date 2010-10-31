class Tag
  include MongoMapper::Document
  
  key :name,              String
  many :jobs, :foreign_key => :job_ids
  
  def self.tags
    self.all.map(&:name)
  end
  
  def jobs
    Job.all(:conditions => {'tag_ids' => self.id})
  end
  
end