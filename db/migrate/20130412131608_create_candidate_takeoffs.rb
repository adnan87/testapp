class CreateCandidateTakeoffs < ActiveRecord::Migration
  def change
    create_table :candidate_takeoffs do |t|
      t.integer :candidate_id
      t.integer :takeoff_id

      t.timestamps
    end
  end
end
