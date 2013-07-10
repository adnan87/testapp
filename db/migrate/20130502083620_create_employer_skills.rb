class CreateEmployerSkills < ActiveRecord::Migration
  def change
    create_table :employer_skills do |t|
      t.integer :employer_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
