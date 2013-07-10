class AddTakeoffToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :takeoff_id, :integer
  end
end
