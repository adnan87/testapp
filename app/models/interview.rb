class Interview < ActiveRecord::Base
  
  STATUS_TYPES = ["Requested", "Approved", "Declined"]
  
  CANDIDATE_STATUS_TYPES = ["Requested", "Accepted", "Declined"]
  
  attr_accessible :candidate_id, :candidate_status, :candidate_status_changed_on, :employer_id, :employer_pitch, :request_date, :status, :status_changed_on
  
  belongs_to :candidate
  belongs_to :employer
  
   def self.search(status)
    if status
      find(:all, :joins => "INNER JOIN candidates ON candidates.id = interviews.candidate_id INNER JOIN employers ON employers.id = interviews.employer_id ", :select => "interviews.*, candidates.email as candidate_email, candidates.name as candidate_name, employers.email as employer_email, employers.name as employer_name", :conditions => ['interviews.status = ?', "#{status}"])
    else
      find(:all, :joins => "INNER JOIN candidates ON candidates.id = interviews.candidate_id INNER JOIN employers ON employers.id = interviews.employer_id ", :select => "interviews.*, candidates.email as candidate_email, candidates.name as candidate_name, employers.email as employer_email, employers.name as employer_name", :conditions => ['interviews.status = ?', "Requested"])
    end
  end
end
