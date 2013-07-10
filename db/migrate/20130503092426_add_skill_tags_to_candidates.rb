class AddSkillTagsToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :skill_tags, :string
  end
end
