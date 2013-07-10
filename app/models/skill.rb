class Skill < ActiveRecord::Base
  attr_accessible :name
  has_many :employer_skills
  has_many :candidate_skills
end
