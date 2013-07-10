class InterviewsController < ApplicationController
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @interviews = Interview.search(params[:status])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employers }
    end
  end
  
  def show
    @interview = Interview.find(params[:id])
    
    @employer = Employer.find(@interview.employer_id)
    @candidate = Candidate.find(@interview.candidate_id)
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def processinterview
    @interview = Interview.find(params[:id])
    
    @employer = Employer.find(@interview.employer_id)
    @employer.about = params[:about]
    #@employer.pitch = params[:pitch]
    @employer.save
    
    @interview.employer_pitch = params[:pitch]
    
    if params[:commit] == 'Approve'
        # Approved 
        
        @interview.status = "Approved"
        @interview.status_changed_on = Time.now
        @interview.candidate_status = "Requested"
        respond_to do |format|
          if @interview.save()
             @employer = Employer.find(@interview.employer_id)
             @candidate = Candidate.find(@interview.candidate_id)
            
            #Notifier.interview_status_change(@interview,@employer,@candidate).deliver - removed as per task #46
            Notifier.candidate_interview_request(@interview,@employer,@candidate).deliver
            #Notifier.employer_status_change(@employer).deliver
            format.html { redirect_to interviews_url, notice: 'Interview Request was successfully Approved.' }
            #format.json { head :no_content }
          else
            format.html { redirect_to interviews_url, notice: 'Error Occured' }
            #format.json { render json: @employer.errors, status: :unprocessable_entity }
          end
        end 
    elsif params[:commit] == 'Decline'
        #Declined
        
        @interview.status = "Declined"
        @interview.status_changed_on = Time.now
        respond_to do |format|
          if @interview.save()
            @candidate = Candidate.find(@interview.candidate_id)
            @employer = Employer.find(@interview.employer_id)
            Notifier.interview_status_change(@interview,@employer,@candidate).deliver
            #Notifier.employer_status_change(@employer).deliver
            format.html { redirect_to interviews_url, notice: 'Interview Request was Declined' }
            #format.json { head :no_content }
          else
            format.html { redirect_to interviews_url, notice: 'Error Occured' }
            #format.json { render json: @employer.errors, status: :unprocessable_entity }
          end
        end
    end
  end
  
  def approve_request
    @interview = Interview.find(params[:id])
    @interview.status = "Approved"
    @interview.status_changed_on = Time.now
    @interview.candidate_status = "Requested"
    respond_to do |format|
      if @interview.save()
         @employer = Employer.find(@interview.employer_id)
         @candidate = Candidate.find(@interview.candidate_id)
        
        #Notifier.interview_status_change(@interview,@employer,@candidate).deliver - removed as per task #46
        Notifier.candidate_interview_request(@interview,@employer,@candidate).deliver
        #Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to interviews_url, notice: 'Interview Request was successfully Approved.' }
        #format.json { head :no_content }
      else
        format.html { redirect_to interviews_url, notice: 'Error Occured' }
        #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def decline_request
    @interview = Interview.find(params[:id])
    @interview.status = "Declined"
    @interview.status_changed_on = Time.now
    respond_to do |format|
      if @interview.save()
        @candidate = Candidate.find(@interview.candidate_id)
        @employer = Employer.find(@interview.employer_id)
        Notifier.interview_status_change(@interview,@employer,@candidate).deliver
        #Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to interviews_url, notice: 'Interview Request was Declined' }
        #format.json { head :no_content }
      else
        format.html { redirect_to interviews_url, notice: 'Error Occured' }
        #format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end


  def sort_interviews
    data = params[:sortby]
    sortby = if(data == "Date Requested")
        "interviews.request_date desc"
      elsif data == "Employer"
        "employer_name asc"
      elsif data == "Candidate"
        "candidate_name asc"
      elsif data == "Status"
          "interviews.status asc"
      else data == "Candidate Response"
        "interviews.candidate_status asc"
      end
     @interviews = Interview
                .select("interviews.*,employers.name as employer_name,employers.email as employer_email,candidates.name as candidate_name,candidates.email as candidate_email,candidates.status")
                .joins(:candidate,:employer)
                .order("#{sortby}")

      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end
end
