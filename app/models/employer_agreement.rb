class EmployerAgreement < ActiveRecord::Base
  attr_accessible :agreement_id, :employer_id, :ipaddress
  
  belongs_to :agreement
  belongs_to :employer
  
  def self.search(agreement_id)
   
    Employer.find(:all, :joins => ["INNER JOIN employer_agreements ON employers.id = employer_agreements.employer_id AND employer_agreements.agreement_id = ", "#{agreement_id}"], :select => "employers.id, employers.email, employers.name, employers.phone, employer_agreements.ipaddress, employer_agreements.created_at")
    
  end
  
end
