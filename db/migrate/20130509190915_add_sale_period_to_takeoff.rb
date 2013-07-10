class AddSalePeriodToTakeoff < ActiveRecord::Migration
  def change
    add_column :takeoffs, :sale_period, :integer
    
    Takeoff.update_all ["sale_period = 3"]
  end
end
