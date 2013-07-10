class Notifier < ActionMailer::Base
  default from: "interviewjet-mailer@interviewjet.com"
  def candidate_signup(candidate)
    @candidate = candidate
    #uploadedfilename =  @params[:resume_file].original_filename
    #attachments[uploadedfilename] = File.read(@params[:resume_file].path)
    subject = "New Candidate Signup Information"
    mail to: "takeoff@interviewjet.com", subject: subject
  end

  def candidate_welcome(candidate)
    @candidate = candidate
    subject = "Welcome on board - Interviewjet"
    mail to: @candidate.email, subject: subject
  end

  def candidate_status_change(candidate)
    @candidate = candidate
    subject = "Interviewjet - Application - Status Change"
    mail to: @candidate.email, subject: subject
  end

  def candidate_featured(candidate)
    @candidate = candidate
    subject = "Interviewjet - Your Profile has been Featured"
    mail to: @candidate.email, subject: subject
  end

  #Employer notifiers

  def employer_signup(employer)
    @employer = employer
    #uploadedfilename =  @params[:resume_file].original_filename
    #attachments[uploadedfilename] = File.read(@params[:resume_file].path)
    subject = "New Employer Signup Information"
    mail to: "takeoff@interviewjet.com", subject: subject
    
  end

  def employer_welcome(employer)
    @employer = employer
    subject = "Welcome on board - Interviewjet"
    mail to: @employer.email, subject: subject
  end

  def employer_status_change(employer)
    @employer = employer
    subject = "Interviewjet - Application - Status Change"
    mail to: @employer.email, subject: subject
  end
  
  # send email to admin when request is received
  def interview_request(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Takeoff - Interview Request"
    
    mail to: "takeoff@interviewjet.com", subject: subject
    
    
  end
  
  # email employer when admin approves or declines
  def interview_status_change(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Takeoff - Interview Request - " + @interview.status
    
    mail to: @employer.email, subject: subject
  end
  
  # email candidate about interview request when admin approves employer request
  def candidate_interview_request(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Congrats!! You have been selected for an Interview"
    
    mail to: @candidate.email, subject: subject
  end
  
  # email admin and employer when candidate accepts or declines request
  def admin_candidate_interview_status_change(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Candidate has " + @interview.candidate_status + " interview request"
    
    mail to: "takeoff@interviewjet.com", subject: subject
    
    
  end
  
  def candidate_interview_status_change(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Candidate has " + @interview.candidate_status + " your interview request"
    
    mail to: @employer.email, subject: subject
  end
  
  # email employer info to candidate when accepted by candidate
  def send_employer_details(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    subject = "Employer Info for your interview"
    
    mail to: @candidate.email, subject: subject
  end
  
  # email candidate info to employer when accepted by candidate
  def send_candidate_details(interview, employer, candidate)
    @interview = interview
    @employer = employer
    @candidate = candidate
    
    #changed title as per Task #41
    subject = "Candidate has " + @interview.candidate_status + " your interview request"
    #subject = "Candidate Profile - " + @candidate.name
    
    mail to: @employer.email, subject: subject
  end
  
end
