class AddAnonymousToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :anonymous, :boolean
    
    Candidate.update_all ["anonymous = false"]
  end
end
