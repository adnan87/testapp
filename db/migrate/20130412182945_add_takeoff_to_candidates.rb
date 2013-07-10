class AddTakeoffToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :takeoff_id, :integer
    Candidate.update_all ["takeoff_id = 1"]
  end
end
