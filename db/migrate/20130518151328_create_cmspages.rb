class CreateCmspages < ActiveRecord::Migration
  def change
    create_table :cmspages do |t|
      t.string :page
      t.string :title
      t.text :content

      t.timestamps
    end
    
    
    Cmspage.create(:page => 'about', :title => 'About Us', :content => '')
    Cmspage.create(:page => 'faq', :title => 'FAQ', :content => '')
    Cmspage.create(:page => 'terms', :title => 'Terms Of Use', :content => '')
    Cmspage.create(:page => 'privacy', :title => 'Privacy', :content => '')
  end
end
