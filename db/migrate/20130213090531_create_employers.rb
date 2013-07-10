class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :email
      t.string :name
      t.string :website
      t.string :about
      t.string :phone
      t.string :status

      t.timestamps
    end
  end
end
