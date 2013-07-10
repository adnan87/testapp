class AddExtraFieldsToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :displayname, :string
    add_column :candidates, :one_liner, :string
    add_column :candidates, :quote, :string
    
    Candidate.update_all ["displayname = name"]
  end
end
