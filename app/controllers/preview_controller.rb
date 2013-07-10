class PreviewController < ApplicationController
  layout :resolve_layout
  
  #homepage...controller
  def index
    @candidate = Candidate.new
    @employer = Employer.new
    @takeoff = Takeoff.limit(1).find_by_active(true)
    @upcomingtakeoff = Takeoff.UpcomingTakeOff(@takeoff.id) if @takeoff
  end
  
  #takeoff...controller
  def takeoff
    @takeoff = Takeoff.limit(1).find_by_active(true)
    @candidate_id = 0;
  
    if (@takeoff)
      if ((@takeoff.enddate) <= DateTime.now.in_time_zone('Eastern Time (US & Canada)')) 
        redirect_to '/crewflew' #if next take off is not found
      end 
    end

    #check if candidate_id is passed to controller
    if (params[:id])      
      @candidate_id = params[:id]  
    end
    
    
    session[:takeoff] = @takeoff.id if @takeoff
    if (!session[:empuser].to_s.blank? && @takeoff) 
      @employer = Employer.limit(1).find_by_email(session[:empuser]) #session[:empuser]
      @candidates = Candidate.find(:all, :joins => ["LEFT JOIN interviews ON candidates.id = interviews.candidate_id AND interviews.employer_id = ", "#{@employer.id}"], :select => "DISTINCT candidates.*, interviews.status as interview_status", :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  }, :order => "candidates.featured_date DESC") 
    else
      @candidates = Candidate.find(:all, :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  })  if @takeoff   
    end

  end
  
  #for previewing the candidate mini-profile and actual profile
  def viewtalent

    @candidate_id = 0;
    
    if (params[:id])
      @candidate_id = params[:id]       
    end
    
    if (@candidate_id != "0")
      
      @candidates = Candidate.find(:all, :conditions => { 'candidates.id' => @candidate_id  })      
    
    end

  end
  
  #for loading the profile info when previewing the candidate  
  #json call  
  def preview_profile
    @candidate = Candidate.find(params[:id])
    
    if (@candidate)
      respond_to do |format|
          format.json { render json: @candidate.to_json(:include => [:skills, :portfolios]), status: :ok }
      end
    else
      respond_to do |format|    
        msg = { :status => "ok", :message => "false"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
  end
  
  #this controller is used for the takeoff ... loads the candidate profile data as a json
  def profile
    @candidate = Candidate.find(params[:id])
    @employer = Employer.limit(1).find_by_email(session[:empuser])
    @interview = Interview.find(:all, :conditions => {'interviews.employer_id' => @employer.id, 'interviews.candidate_id' => @candidate.id, 'interviews.takeoff_id' => session[:takeoff]})
    
    if (@candidate)
      respond_to do |format|
        if (!@interview.blank?)      
          @candidate["candidate_interview"] = @interview.to_json();
          format.json { render json: @candidate.to_json(:include => [:skills, :portfolios]), status: :ok }
          
        else
          format.json { render json: @candidate.to_json(:include => [:skills, :portfolios]), status: :ok }
        end
      end
    else
      respond_to do |format|    
        msg = { :status => "ok", :message => "false"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
   
  end
  
  #this is the crewflew controller.. past sale period
  
  def crewflew
    @takeoff = Takeoff.limit(1).find_by_active(true)
    @upcomingtakeoff = Takeoff.UpcomingTakeOff(@takeoff.id)
    session[:takeoff] = @takeoff.id
    if (!session[:empuser].to_s.blank?)
      @employer = Employer.limit(1).find_by_email(session[:empuser]) #session[:empuser]
      @candidates = Candidate.find(:all, :joins => ["LEFT JOIN interviews ON candidates.id = interviews.candidate_id AND interviews.employer_id = ", "#{@employer.id}"], :select => "candidates.*, interviews.status as interview_status", :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  })
    else
      @candidates = Candidate.find(:all, :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  })      
    end
  end
  
  #loads the employer info and checks if the employer has signed any agreement
  def employer
    @employer = Employer.limit(1).find_by_email(session[:empuser])

    @agreement = Agreement.find(:first, :conditions => { :isactive => true})
    
    @employer['agreement_content'] = @agreement.content
    
    @employeragreement = EmployerAgreement.find(:first, :conditions => {:employer_id => @employer.id, :agreement_id => @agreement.id})
  
    if (@employeragreement)
      @employer['agreement_signed'] = true
    else
      @employer['agreement_signed'] = false
    end
    
    respond_to do |format|
      format.json { render json: @employer }
    end
  end
    
  # POST /candidates.json
  # used for saving the talent application
  def talent
    @candidate = Candidate.new(params[:candidate])
    @candidate.status = 'Requested'
    @candidate.availability_status = "Immedidate"
    @candidate.candidate_pitch = ""
    @candidate.featured = false
    @candidate.job_role = "Others"
    @candidate.anonymous = false
    # log the candidate email address to emaillist
    @emaillist_new = Emaillist.new()
    @emaillist_new.email = @candidate.email
    @emaillist_new.type = "Candidate"
    @emaillist_new.ipaddress = request.remote_ip
    @emaillist_new.save
    # end email logging
    
    respond_to do |format|
      if @candidate.save
        Notifier.candidate_signup(@candidate).deliver
        Notifier.candidate_welcome(@candidate).deliver
        #format.html { redirect_to thanks_home_path, notice: 'Your application is accepted and under review.' }
        format.js  { render 'talent.js.erb' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.js { render 'talent_failure.js.erb' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #used for saving the employer requests
  def employerrequest
    @employer = Employer.new(params[:employer])
    @employer.email =  @employer.email.downcase
    
    @employerdomain = Employerdomain.verifydomain(@employer.email)
    if @employerdomain
      @employer.status = 'Approved'
      @employer.source = "WhiteListed"
    else
      @employer.status = 'Requested'
      @employer.source = "Others"
    end
    
    if (@employer.website.blank?)
      @employer.website = "http://www." + @employer.email.downcase.split("@").last
    end
     
    session[:empuser] = @employer.email.downcase

    respond_to do |format|
      if @employer.save
        begin
          mailchimp = Hominid::API.new('b6d6a715dbf04980a754c2b4673c579e-us5')
          mailchimp.list_subscribe("6d67f5c358", @employer.email, {'FNAME' => @employer.firstname, 'LNAME' => @employer.lastname}, 'html', false, true, true, false) if params[:employer]
        rescue => e
        end 
        Notifier.employer_signup(@employer).deliver
        Notifier.employer_welcome(@employer).deliver

        if @employer.status == 'Approved'
          Notifier.employer_status_change(@employer).deliver
          format.html { redirect_to takeoff_landing_home_url, notice: 'Congrats!! Your account is PreApproved. Logged in as ' +  @employer.email }
          format.json { render json: @employer, status: :created, location: @employer }
        else
          format.html { redirect_to thanks_home_path, notice: 'Your application is accepted and under review.' }
          format.json { render json: @employer, status: :created, location: @employer }
        end

      else
        format.html { render action: "featured" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #saves the interview request
  def requestinterview


    #update the employer record
    @employer = Employer.find_by_email(session[:empuser])
    @employer.firstname = params[:employer_firstname]
    @employer.lastname = params[:employer_lastname]
    @employer.companyname = params[:employer_companyname]
    @employer.website = params[:employer_website]
    @employer.about = params[:employer_about]
    @employer.pitch = params[:employer_pitch]
    @employer.save
    #update ends
    @interview = Interview.new()
    @interview.request_date = Time.now;
    @interview.employer_id = @employer.id


    if params[:accept_tos] && params[:hTOS] == "0"
      @employeragreement = EmployerAgreement.new()
      @agreement = Agreement.find(:first, :conditions => { :isactive => true})
      @employeragreement.employer_id = @employer.id
      @employeragreement.agreement_id = @agreement.id
      @employeragreement.ipaddress = request.remote_ip
      @employeragreement.save() 
    end
    
    @interview.candidate_id = params[:candidate_id]
    @interview.status ="Requested"
    @interview.candidate_status = ""
    @interview.employer_pitch = params[:employer_pitch]
    @interview.takeoff_id = session[:takeoff]

    @candidate = Candidate.find(params[:candidate_id])
    respond_to do |format|
      if @interview.save
        Notifier.interview_request(@interview,@employer,@candidate).deliver
        format.js  { render 'requestinterview.js.erb' }
        format.html { redirect_to takeoff_landing_home_path, notice: 'Thank you!! We have received your request. We will get back to you soon.' }
      else
        format.js  { render 'requestinterview_failure.js.erb' }
        format.html { redirect_to takeoff_landing_home_path, notice: 'Sorry there seems to be an issue processing your request' }
      end
    end
  end

  def content
    @cmspage = Cmspage.limit(1).find_by_page(params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cmspages }
    end
  end
  
  def preview_takeoff
    @takeoff = Takeoff.limit(1).find_by_id(params[:id])
    @candidates = Candidate.find(:all, :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  })      
  end
  #this is used to pick the layout file based on the controller
  private

  def resolve_layout
    case action_name
    when "index"
      "index"
    when "takeoff"
      "takeoff"
    when "crewflew"
      "crewflew"
    when "viewtalent"
      "viewtalent"
    when "preview_takeoff"
      "preview_takeoff"
    when "content"
      "content"
    else
      "application"
    end
  end
end
