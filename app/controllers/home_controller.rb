class HomeController < ApplicationController
  def index
    @employer = Employer.new()
  end

  def thanks
  end

  def admin
  end

  def employer
    @employer = Employer.new()
  end

  def featured
    @candidate = Candidate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidate }
    end
  end
  
  def verifycandidate
    @candidate = Candidate.validateemail(params[:email])
    if (@candidate)
      respond_to do |format|
        msg = { :status => "ok", :message => "false"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      respond_to do |format|
        msg = { :status => "ok", :message => "true"}
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
    
  end
 
  def createfeatured
    @candidate = Candidate.new(params[:candidate])
    @candidate.status = 'Requested'
    @candidate.availability_status = "Immedidate"
    @candidate.candidate_pitch = ""
    @candidate.featured = false

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
        format.html { redirect_to thanks_home_path, notice: 'Your application is accepted and under review.' }
        format.js { render 'createfeatured.js.erb' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "featured" }
        format.js { render 'createfeatured.js.erb' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def viewcandidate
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  def viewprofile
    @candidate = Candidate.find(params[:id])

    @employer = Employer.limit(1).find_by_email(session[:empuser])

    @agreement = Agreement.find(:first, :conditions => { :isactive => true})
    
    @employeragreement = EmployerAgreement.find(:first, :conditions => {:employer_id => @employer.id, :agreement_id => @agreement.id})
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  def validateemployer
    @employer = Employer.validateemail(params[:email].downcase)
    session[:empuser] = ''
    if (@employer)
      respond_to do |format|
        if (@employer.status == "Approved")
          session[:empuser] = params[:email].downcase
          msg = { :status => "ok", :message => "Approved"}
        else
          session[:empuser] = ""
          msg = { :status => "ok", :message => "Pending"}
        end
        format.json  { render :json => msg } # don't do msg.to_json
      end
    else
      @employerdomain = Employerdomain.verifydomain(params[:email].downcase)
      respond_to do |format|
        if @employerdomain
          #check the status of the domain and take necessary action
          case @employerdomain.status
          when "WhiteListed"
            msg = { :status => "ok", :message => "WhiteListed"}
          when "PreApproved"
            @new_employer = Employer.new()
            @new_employer.email = params[:email].downcase;
            @new_employer.firstname = ""
            @new_employer.lastname = ""
            @new_employer.name = "" #params[:email].downcase.split("@").last - changed as per Task 40
            @new_employer.companyname = "" #params[:email].downcase.split("@").last #- changed as per Task 36
            @new_employer.website = "http://www." + params[:email].downcase.split("@").last
            @new_employer.status = "Approved"
            @new_employer.source = "PreApproved"
            @new_employer.save
            session[:empuser] =  @new_employer.email.to_s.downcase
            begin
              mailchimp = Hominid::API.new('b6d6a715dbf04980a754c2b4673c579e-us5')
              mailchimp.list_subscribe("6d67f5c358", @new_employer.email, {'FNAME' => @new_employer.firstname, 'LNAME' => @new_employer.lastname}, 'html', false, true, true, false) if params[:email]
            rescue => e
            end 
            Notifier.employer_signup(@new_employer).deliver
            Notifier.employer_welcome(@new_employer).deliver
            Notifier.employer_status_change(@new_employer).deliver
            msg = { :status => "ok", :message => "PreApproved"}
          else
            
            msg = { :status => "ok", :message => "Declined"}
          end
        else
            msg = { :status => "ok", :message => "New"}
        end

        
        format.json  { render :json => msg } # don't do msg.to_json
      end
    end
    
  end
  def verfiyemployer
    @employer = Employer.validateemail(params[:email])

    ##check if the email exists as an employer account, else proceed with validating the email against white/blacklist
    session[:empuser] = params[:email].downcase
    
    # log the employer email address to emaillist
    @emaillist_new = Emaillist.new()
    @emaillist_new.email = session[:empuser]
    @emaillist_new.type = "Employer"
    @emaillist_new.ipaddress = request.remote_ip
    @emaillist_new.save
    # end email logging
    
    if (@employer)
      respond_to do |format|
        if (@employer.status == "Approved")
          format.html { redirect_to takeoff_landing_home_url, notice: 'Logged In as ' + @employer.email  }
        else
          format.html { redirect_to root_url, alert: 'We are currently reviewing your application '  }
        end
      end
    else
      @employerdomain = Employerdomain.verifydomain(params[:email])
      respond_to do |format|
        if @employerdomain
          #check the status of the domain and take necessary action
          case @employerdomain.status
          when "WhiteListed"
            format.html { redirect_to employer_home_url, notice: 'Congrats!! You can signup for your account now' }
          when "PreApproved"
            @new_employer = Employer.new()
            @new_employer.email = params[:email];
            @new_employer.name = "" #params[:email].downcase.split("@").last - changed as per Task 40
            @new_employer.companyname = params[:email].downcase.split("@").last #- changed as per Task 36
            @new_employer.website = "http://www." + params[:email].downcase.split("@").last
            @new_employer.status = "Approved"
            @new_employer.source = "PreApproved"
            @new_employer.save

            Notifier.employer_signup(@new_employer).deliver
            Notifier.employer_welcome(@new_employer).deliver
            Notifier.employer_status_change(@new_employer).deliver
            format.html { redirect_to takeoff_landing_home_url, notice: 'Congrats!! Your account is PreApproved. Logged in as ' +  @new_employer.email }
          else
          format.html { redirect_to root_url, alert: 'Sorry!! Currently we cannot process your request. Use one of our preapproved emails to sign-in' }
          end
        else
          format.html { redirect_to employer_home_url, alert: 'New Employer Signup Request.' }
        #format.json { render json: @employerdomain, status: :created, location: @employerdomain }
        end
      end
    end
  end

  def createemployer
    @employer = Employer.new(params[:employer])

    @employerdomain = Employerdomain.verifydomain(@employer.email)
    if @employerdomain
      @employer.status = 'Approved'
      @employer.source = "WhiteListed"
    else
      @employer.status = 'Requested'
      @employer.source = "Others"
    end

    session[:empuser] = @employer.email.downcase

    respond_to do |format|
      if @employer.save

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

  def takeoff_landing

    if session[:empuser]

      @employer = Employer.limit(1).find_by_email(session[:empuser])

      @takeoff = Takeoff.limit(1).find_by_active(true)

      @candidates = Candidate.find(:all, :joins => ["LEFT JOIN interviews ON candidates.id = interviews.candidate_id AND interviews.employer_id = ", "#{@employer.id}"], :select => "candidates.*, interviews.status as interview_status", :conditions => { 'candidates.featured' => true, 'candidates.takeoff_id' => @takeoff.id  })

      #Candidate.joins("LEFT JOIN interviews ON candidates.id = interviews.candidate_id")
      #Candidate.featured_candidates

      

      if @takeoff
        session[:takeoff] = @takeoff.id
        @takeoffdate = @takeoff.enddate.strftime("%m/%d/%Y");
      else
        session[:takeoff] = 0
        @takeoffdate = Time.now.strftime("%m/%d/%Y")
      end
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @candidates }
      end
    else
      redirect_to root_url
    end

  end

  def requestinterview

    @interview = Interview.new()

    @interview.request_date = Time.now;
    @interview.employer_id = params[:employer_id]

    #update the employer record
    @employer = Employer.find(params[:employer_id])
    @employer.name = params[:name]
    @employer.companyname = params[:companyname]
    @employer.website = params[:website]
    @employer.about = params[:about]
    @employer.pitch = params[:pitch]
    @employer.save
    #update ends


    if params[:accept_tos]
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
    @interview.employer_pitch = params[:pitch]
    @interview.takeoff_id = session[:takeoff]

    @candidate = Candidate.find(params[:candidate_id])
    respond_to do |format|
      if @interview.save
        Notifier.interview_request(@interview,@employer,@candidate).deliver
        
        format.html { redirect_to takeoff_landing_home_path, notice: 'Thank you!! We have received your request. We will get back to you soon.' }
      else
        format.html { redirect_to takeoff_landing_home_path, notice: 'Sorry there seems to be an issue processing your request' }
      end
    end
  end

  def review
    @interview = Interview.find(params[:id])

    @employer = Employer.find(@interview.employer_id)
    @candidate = Candidate.find(@interview.candidate_id)

    respond_to do |format|
      format.html # show.html.erb
    end

  end

  def accept_interview_request
    @interview = Interview.find(params[:id])

    @interview.candidate_status = "Accepted"
    @interview.candidate_status_changed_on = Time.now
    respond_to do |format|
      if @interview.save()
        #Notifier.employer_status_change(@employer).deliver
        
        @employer = Employer.find(@interview.employer_id)
        @candidate = Candidate.find(@interview.candidate_id)
        
        Notifier.admin_candidate_interview_status_change(@interview,@employer,@candidate).deliver
        #commented as per Task #41
        #Notifier.candidate_interview_status_change(@interview,@employer,@candidate).deliver
        Notifier.send_employer_details(@interview,@employer,@candidate).deliver
        Notifier.send_candidate_details(@interview,@employer,@candidate).deliver
        
        
        format.html { redirect_to root_url, notice: 'Interview Request was successfully accepted.' }
      #format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'Error Occured' }
      #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def decline_interview_request
    @interview = Interview.find(params[:id])
    @interview.candidate_status = "Declined"
    @interview.candidate_status_changed_on = Time.now

    respond_to do |format|
      if @interview.save()
        
        @employer = Employer.find(@interview.employer_id)
        @candidate = Candidate.find(@interview.candidate_id)
        Notifier.admin_candidate_interview_status_change(@interview,@employer,@candidate).deliver
        Notifier.candidate_interview_status_change(@interview,@employer,@candidate).deliver
        
        #Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to root_url, notice: 'Interview Request was Declined' }
      #format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'Error Occured' }
      #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def acceptrequest
    @interview = Interview.find(params[:id])

    @interview.candidate_status = "Accepted"
    @interview.candidate_status_changed_on = Time.now
    respond_to do |format|
      if @interview.save()
        #Notifier.employer_status_change(@employer).deliver
        
        @employer = Employer.find(@interview.employer_id)
        @candidate = Candidate.find(@interview.candidate_id)
        
        Notifier.admin_candidate_interview_status_change(@interview,@employer,@candidate).deliver
        #commented as per Task #41
        #Notifier.candidate_interview_status_change(@interview,@employer,@candidate).deliver
        Notifier.send_employer_details(@interview,@employer,@candidate).deliver
        Notifier.send_candidate_details(@interview,@employer,@candidate).deliver
        
        
        format.html { redirect_to root_url, notice: 'Interview Request was successfully accepted.' }
      #format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'Error Occured' }
      #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def declinerequest
    @interview = Interview.find(params[:id])
    @interview.candidate_status = "Declined"
    @interview.candidate_status_changed_on = Time.now

    respond_to do |format|
      if @interview.save()
        
        @employer = Employer.find(@interview.employer_id)
        @candidate = Candidate.find(@interview.candidate_id)
        Notifier.admin_candidate_interview_status_change(@interview,@employer,@candidate).deliver
        Notifier.candidate_interview_status_change(@interview,@employer,@candidate).deliver
        
        #Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to root_url, notice: 'Interview Request was Declined' }
      #format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'Error Occured' }
      #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end
end