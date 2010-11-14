require File.dirname(__FILE__) + '/../spec_helper'
include Geokit::Geocoders

describe "Search" do
  
  it "should fail if category doesn't exist" do
    lambda { Job.search("FAKE") }.should raise_error
  end
  
  it "should not find non moderated jobs" do
    job = Factory.create(:job_non_moderated)
    Job.search(job.category).should_not include(job)
  end
      
  it "should find jobs in provided category" do
    job = Factory.create(:job_moderatable, :is_moderated => true)
    Job.search(job.category).should include(job)
  end
  
  it "should not find jobs in other categories" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :category => Category::PROGRAMMING)
    Job.search(Category::DESIGN).should_not include(job)
  end
  
  it "should not find jobs created more than 30 days ago" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :date => 31.days.ago)
    Job.search(job.category).should_not include(job)
  end
  
  it "should find jobs created 30 days ago" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :date => 30.days.ago)
    Job.search(job.category).should include(job)
  end
  
  it "should work when no tag is provided" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :tags => [])
    Job.search(job.category).should include(job)
  end
  
  it "should work when tags are provided" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :tags => ["c++", "rails", "javascript"])
    Job.search(job.category, ["javascript"]).should include(job)
    Job.search(job.category, ["javascript", "c++"]).should include(job)
    Job.search(job.category, ["javascript", "c++", "rails"]).should include(job)
  end

  it "nb_tags_included should return the number of tags included" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :tags => ["c++", "rails", "javascript"])
    Job.send(:nb_tags_included, ["javascript"], job).should == 1
    Job.send(:nb_tags_included, ["c++", "javascript"], job).should == 2
    Job.send(:nb_tags_included, ["javascript", "rails", "c++", "somethingelse"], job).should == 3
  end
  
  it "should order by number of tags" do
    job1 = Factory.create(:job_moderatable, :is_moderated => true, :tags => ["test_order_1"])
    job2 = Factory.create(:job_moderatable, :is_moderated => true, :tags => ["test_order_1", "test_order_2"])
    job3 = Factory.create(:job_moderatable, :is_moderated => true, :tags => ["test_order_1", "test_order_2", "test_order_3"])
    Job.search(job1.category, ["test_order_0", "test_order_1", "test_order_2"]).should == [job3, job2, job1]
  end
  
  it "should not geocode if location is blank or is 'anywhere'" do
    job = Factory.create(:job_moderatable, :is_moderated => true)
    Job.search(job.category, [], "")
    MultiGeocoder.should_not_receive(:geocode)
    Job.search(job.category, [], "anywhere")
    MultiGeocoder.should_not_receive(:geocode)
  end
  
  it "should find by zipocde" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "113 avenue de la dhuys"}) #zipcode = 93170
    puts job.address.inspect
    Job.search(job.category, [], "93170").should include(job)
  end
  
  it "should find by city" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "Paris"})
    Job.search(job.category, [], "paris").should include(job)
  end
  
  # it actually works thanks to the search by state ... so I should find a better test 
  it "should find near city" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "Bagnolet"})
    Job.search(job.category, [], "Paris").should include(job)
  end
  
  it "should find by country" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "Paris"})
    Job.search(job.category, [], "France").should include(job)
  end
  
  it "should find by country code" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "Paris"})
    Job.search(job.category, [], "FR").should include(job)
  end
  
  it "should find by state" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "San Francisco"})
    Job.search(job.category, [], "CA").should include(job)
    Job.search(job.category, [], "california").should include(job)
  end
  
  it "should not find jobs not in the good location" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "San Francisco"})
    Job.search(job.category, [], "NY").should_not include(job)
  end
  
end