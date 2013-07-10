class AddSkillSetToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :skill_set, :text
    
    Candidate.update_all ["skill_set = ''"]
  end
end
