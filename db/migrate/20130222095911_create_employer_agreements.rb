class CreateEmployerAgreements < ActiveRecord::Migration
  def change
    create_table :employer_agreements do |t|
      t.integer :employer_id
      t.integer :agreement_id
      t.string :ipaddress

      t.timestamps
    end
  end
end
