class JobsController < ApplicationController
  
  def index
    @jobs = Job.paginate :page => params[:page], :order => 'date DESC', :per_page => 12, :conditions => {'is_moderated' => true}
  end
  
end
