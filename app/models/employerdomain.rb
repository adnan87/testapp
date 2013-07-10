class Employerdomain < ActiveRecord::Base
  #STATUS_TYPES = ["WhiteListed", "BlackListed", "PreApproved"]
  #STATUS_TYPES = ["WhiteListed", "BlackListed"]
  STATUS_TYPES = ["PreApproved", "BlackListed"]
  
  attr_accessible :employer_domain, :status
  validates :employer_domain, :presence => true, :uniqueness => true
  
  def self.search(status)
    if status
      find(:all, :conditions => ['status = ?', "#{status}"])
    else
      find(:all, :conditions => ['status = ?', "PreApproved"]) #changed the default to PreApproved
    end
  end
  
  def self.verifydomain(email)
    domain = email.downcase.split("@").last
    if email
      find(:first, :conditions => ['employer_domain = ?', "#{domain}"])
    end
  end
end
