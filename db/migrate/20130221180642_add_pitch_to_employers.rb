class AddPitchToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :pitch, :string
  end
end
