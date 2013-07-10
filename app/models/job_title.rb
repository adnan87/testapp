class JobTitle < ActiveRecord::Base
  attr_accessible :name
  has_many :employer_job_titles
  belongs_to :employer
end
