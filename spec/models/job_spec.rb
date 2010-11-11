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
  
end