class AddAvailabilityStatusToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :availability_status, :string
    
    Candidate.update_all ["availability_status = ?", "Immediate"]
  end
end
