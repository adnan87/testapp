class CreateEmaillists < ActiveRecord::Migration
  def change
    create_table :emaillists do |t|
      t.string :email
      t.string :type
      t.string :ipaddress

      t.timestamps
    end
  end
end
