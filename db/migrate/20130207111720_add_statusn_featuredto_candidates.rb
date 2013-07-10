class AddStatusnFeaturedtoCandidates < ActiveRecord::Migration
  def up
     add_column :candidates, :status, :string
     add_column :candidates, :featured, :boolean
     add_column :candidates, :featured_date, :datetime
  end

  def down
  end
end
