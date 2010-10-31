class Admin::JobsController < Admin::ApplicationController
  
  def index
    @jobs = Job.paginate :page => params[:page], :order => 'date DESC', :per_page => 25
    @tags = Tag.all
  end
  
  def update
    job = Job.find(params[:id])
    if params[:commit] == "Save and Moderate"
      job.is_moderated = true
    end
    job.update_attributes(params[:job])
    redirect_to admin_jobs_path
  end
  
end
