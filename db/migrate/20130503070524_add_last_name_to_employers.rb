class AddLastNameToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :lastname, :string
  end
end
