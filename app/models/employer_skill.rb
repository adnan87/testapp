class EmployerSkill < ActiveRecord::Base
  
  attr_accessible :employer_id, :skill_id
  belongs_to :employer
  belongs_to :skill
end
