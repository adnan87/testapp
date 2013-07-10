class ChangeCandidatePitchInCandidate < ActiveRecord::Migration
  def up
    change_column :candidates, :candidate_pitch, :text
  end

  def down
    change_column :candidates, :candidate_pitch, :string
  end
end
