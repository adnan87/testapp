class ReportsController < ApplicationController
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @reportfilter = params[:filter]
    
    @startdate = Date.today.beginning_of_day;
    @enddate = Date.today.end_of_day;
    
    if @reportfilter == "week"
      @startdate = Date.today.at_beginning_of_week.beginning_of_day
      @enddate = Date.today.end_of_day
    end
    
    if @reportfilter == "month"
      @startdate = Date.today.at_beginning_of_month.beginning_of_day
      @enddate = Date.today.end_of_day
    end
    
    @candidate = Candidate.where(:created_at => @startdate..@enddate)  
    @employer = Employer.where(:created_at => @startdate..@enddate)  
    
    @interview_requested = Interview.where(:created_at => @startdate..@enddate, :status => "Requested") 
    @interview_accepted = Interview.where(:status_changed_on => @startdate..@enddate, :status => "Approved") 
    @interview_declined = Interview.where(:status_changed_on => @startdate..@enddate, :status => "Declined") 
    
    if @reportfilter == "all"
      @candidate = Candidate.find(:all)
      @employer = Employer.find(:all)
      
      @interview_requested = Interview.find(:all, :conditions => { :status => "Requested"} ) 
      @interview_accepted = Interview.find(:all, :conditions => { :status => "Approved"} ) 
      @interview_declined = Interview.find(:all, :conditions => { :status => "Declined"} )
    end
    
    respond_to do |format|
       format.html
    end
    
  end
end
