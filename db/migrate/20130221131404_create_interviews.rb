class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.datetime :request_date
      t.integer :employer_id
      t.integer :candidate_id
      t.string :employer_pitch
      t.string :status
      t.datetime :status_changed_on
      t.string :candidate_status
      t.datetime :candidate_status_changed_on

      t.timestamps
    end
  end
end
