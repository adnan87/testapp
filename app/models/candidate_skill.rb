class CandidateSkill < ActiveRecord::Base
  attr_accessible :candidate_id, :skill_id
  
  belongs_to :candidate
  belongs_to :skill
end
