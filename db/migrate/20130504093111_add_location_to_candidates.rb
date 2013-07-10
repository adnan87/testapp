class AddLocationToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :location, :string
    Candidate.update_all ["location = 'New York City, NYC'"]
  end
end
