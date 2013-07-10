class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :linkedin_url
      t.string :other_url
      t.text :resume
      t.string :resume_file

      t.timestamps
    end
  end
end
