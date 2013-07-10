class AddFirstNameToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :firstname, :string
    
    Employer.update_all ["firstname = name"]
  end
end
