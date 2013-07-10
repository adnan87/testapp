class CreateEmployerJobTitles < ActiveRecord::Migration
  def change
    create_table :employer_job_titles do |t|
      t.integer :employer_id
      t.integer :job_title_id

      t.timestamps
    end
  end
end
