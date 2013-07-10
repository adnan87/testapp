class EmployerJobTitle < ActiveRecord::Base
  attr_accessible :employer_id, :job_title_id
  belongs_to :employer
  belongs_to :job_title
end
