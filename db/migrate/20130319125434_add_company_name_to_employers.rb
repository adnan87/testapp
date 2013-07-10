class AddCompanyNameToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :companyname, :string
  end
end
