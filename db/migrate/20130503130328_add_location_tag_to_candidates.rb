class AddLocationTagToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :location_tag, :string
    
    Candidate.update_all ["location_tag = 'NYC'"]
  end
end
