class CreateEmployerdomains < ActiveRecord::Migration
  def change
    create_table :employerdomains do |t|
      t.string :employer_domain
      t.string :status

      t.timestamps
    end
  end
end
