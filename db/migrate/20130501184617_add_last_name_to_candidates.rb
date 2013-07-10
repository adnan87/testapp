class AddLastNameToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :lastname, :string
  end
end
