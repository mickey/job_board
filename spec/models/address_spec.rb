require File.dirname(__FILE__) + '/../spec_helper'

describe Job do
  
  it "should geocode on save" do
    job = Factory.create(:job_moderatable, :is_moderated => true, :address => {:origin => "Paris"})
    job.address.city.should == "Paris"
    job.address.country.should == "France"
    job.address.country_code.should == "FR"
  end
  
end