class AddCandidatePitchToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :candidate_pitch, :string
  end
end
