class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.string :title
      t.string :content
      t.string :version
      t.boolean :isactive

      t.timestamps
    end
  end
end
