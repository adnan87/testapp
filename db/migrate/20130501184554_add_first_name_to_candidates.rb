class AddFirstNameToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :firstname, :string
    Candidate.update_all ["firstname = name"]
  end
end
