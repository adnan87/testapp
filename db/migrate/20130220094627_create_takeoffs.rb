class CreateTakeoffs < ActiveRecord::Migration
  def change
    create_table :takeoffs do |t|
      t.string :name
      t.datetime :startdate
      t.datetime :enddate
      t.boolean :active

      t.timestamps
    end
  end
end
