class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.integer :candidate_id
      t.string :thumbnail_image
      t.string :slider_image
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
