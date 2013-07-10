class Candidate < ActiveRecord::Base

  before_save :abs_linkedin_url
  before_save :abs_other_url
  before_save :full_name
  
  AVAILABILITY_TYPES = ["Immediate", "4 weeks", "3 months", "6 months", "Passively Looking"]
  JOB_ROLES = ["Back End Developer", "Front End Developer", "Mobile Developer", "Designer", "Sys Admin", "Project Manager", "Others"]
  
  attr_accessible :email, :linkedin_url, :name, :other_url, :phone, :resume, :resume_file, :status,
                  :featured, :featured_date, :availability_status, :candidate_pitch,
                  :background_image, :profile_image, :displayname, :one_liner, :quote, :takeoff_id,
                  :firstname, :lastname, :job_role, :skill_tags, :location_tag, :location, :anonymous, :skill_set
                  
  attr_accessible :skill_ids
  attr_accessible :portfolios_attributes
  
  validates :email, :firstname, :lastname, :presence => true
  validates :email, :email => true, :uniqueness => { :message => "already exists in our system. We are currently reviewing your profile" }
  #validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  has_many  :interviews
  has_one :takeoff
  has_many :candidate_skills
  has_many :skills, through: :candidate_skills
  
  has_many :portfolios, :dependent => :destroy
  accepts_nested_attributes_for :portfolios, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  
  mount_uploader :resume_file, CandidateResumeFileUploader
  mount_uploader :background_image, CandidateBackgroundImageUploader
  mount_uploader :profile_image, CandidateProfileImageUploader

  def self.validateemail(email)
    if email
      find(:first, :conditions => ['email = ?', "#{email.downcase}"])
    end
  end
  
  def self.search(status)
    if status
      find(:all, :conditions => ['status = ? AND featured = false', "#{status}"])
    else
      find(:all, :conditions => ['status = ? AND featured = false', "Requested"])
    end
  end

  def self.featured_candidates
  
    Candidate.find(:all, :joins => ["INNER JOIN takeoffs ON candidates.takeoff_id = takeoffs.id AND candidates.featured = 'true' "], :select => "candidates.id, candidates.email, candidates.name, candidates.phone, candidates.featured_date, candidates.takeoff_id, takeoffs.name as takeoffname")
    
  end

  private

  def abs_linkedin_url
    if !self.linkedin_url.blank?
      self.linkedin_url = (self.linkedin_url.start_with? "http://") ? self.linkedin_url : ("http://" + self.linkedin_url)
    end
  end
  private

  def abs_other_url
    if !self.other_url.blank?
      self.other_url = (self.other_url.start_with? "http://") ? self.other_url : ("http://" + self.other_url)
    end
  end
  
  def full_name
    self.name = self.firstname + " " + self.lastname
  end

  def self.email
    self.email = self.email.gsub(" ","")
  end
end
