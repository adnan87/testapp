class Agreement < ActiveRecord::Base
  attr_accessible :content, :isactive, :title, :version
  
  validates :title, :content, :version, :presence => true
  validates :version, :uniqueness => true
  
  has_many :employeragreements
  
end
