class AddJobRoleToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :job_role, :string
    Candidate.update_all ["job_role = 'Others'"]
  end
end
