require File.dirname(__FILE__) + '/../spec_helper'

describe Job do
  
  describe "On Moderation" do
    
    it "should save if everything's ok" do
      Factory.build(:job_moderatable, :is_moderated => true).save.should == true
    end
    
    it "should include a category" do
      job = Factory.create(:job_moderatable, :category => nil)
      job.update_attributes(:is_moderated => true).should == false
    end
    
    it "should include at least one tag" do
      job = Factory.create(:job_moderatable, :tags => [])
      job.update_attributes(:is_moderated => true).should == false
    end
    
    it "should add tags to tags_list" do
      job = Factory.create(:job_moderatable, :is_moderated => true)
      job.tags_list.sort.should == job.tags.map(&:name).sort
    end
    
    it "should update tags_list on update" do
      job = Factory.create(:job_moderatable, :is_moderated => true)
      job.tags = ["c++", "js", "rails"]
      job.save
      job.tags_list.sort.should == ["c++", "js", "rails"].sort
    end
    
  end
  
  describe "Search" do
    
    it "should fail if category doesn't exist" do
      lambda { Job::Search.find("FAKE") }.should raise_error
    end
    
    it "should not find non moderated jobs" do
      job = Factory.create(:job_non_moderated)
      Job::Search.find(job.category).should_not include(job)
    end
    
    it "should find jobs in provided category" do
      job = Factory.create(:job_moderatable, :is_moderated => true)
      Job::Search.find(job.category).should include(job)
    end
    
    it "should not find jobs in other categories" do
      job = Factory.create(:job_moderatable, :is_moderated => true, :category => Category::PROGRAMMING)
      Job::Search.find(Category::DESIGN).should_not include(job)
    end
    
    it "should work when no tag is provided" do
      job = Factory.create(:job_moderatable, :is_moderated => true, :tags => [])
      Job::Search.find(job.category).should include(job)
    end
    
  end
  
end