class ChangeContentDataTypeInAgreements < ActiveRecord::Migration
  def up
    change_column :agreements, :content, :text
  end

  def down
    change_column :agreements, :content, :string
  end
end
