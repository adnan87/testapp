class AddSourceToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :source, :string
  end
end
