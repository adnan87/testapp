class AddProfileImagesToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :background_image, :string
    add_column :candidates, :profile_image, :string
  end
end
