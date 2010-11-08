require File.dirname(__FILE__) + '/../spec_helper'

# key :is_moderated,  Boolean, :default => false, :required => true
# key :source,        String, :required => true
# 
# key :title,         String, :required => true
# key :date,          DateTime, :required => true
# key :description,   String, :required => true
# key :url,           String
# key :tags,          Array
# key :schedule,      String
# key :category,      String
# key :tag_ids,       Array, :required => false  # dragonfly stuff

Factory.define :job do |j|
  j.is_moderated      false
  j.source            "http://github.com"
  j.title             "Super Awesome Dev"
  j.date              Date.yesterday
  j.description       "Description of the best job ever"
end

Factory.define :job_moderatable, :parent => :job do |f|  
  f.category          Category::PROGRAMMING
  f.tags              ["c++", "rails"]
end

Factory.define :job_non_moderated, :parent => :job do |f|  
  f.is_moderated      false
  f.category          Category::PROGRAMMING
end