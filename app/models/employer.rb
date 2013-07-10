class Employer < ActiveRecord::Base
  before_save :abs_website_url
  before_save :full_name
  STATUS_TYPES = ["Approved", "WaitListed", "Declined", "Requested", "PreApproved"]
  
  
  attr_accessible :about, :email, :name, :phone, :status, :website, :source, :companyname, :pitch, :firstname, :lastname
  attr_accessible :job_title_ids, :skill_ids
  
  validates :email, :presence => true
  validates :email, :uniqueness => true
  
  has_many :interviews
  has_many :employeragreements
  has_many :employer_skills
  has_many :skills, through: :employer_skills
  
  has_many :employer_job_titles
  has_many :job_titles, through: :employer_job_titles
  
  def self.search(status)
    if status
      find(:all, :conditions => ['status = ?', "#{status}"])
    else
      find(:all, :conditions => ['status = ?', "Requested"])
    end
  end
  
  def self.validateemail(email)
    if email
      find(:first, :conditions => ['email = ?', "#{email.downcase}"])
    end
  end
  
  private

  def abs_website_url
    if !self.website.blank?
      self.website = (self.website.start_with? "http://") ? self.website : ("http://" + self.website)
    end 
  end
  
  def full_name
    self.name = self.firstname + " " + self.lastname
  end
end
