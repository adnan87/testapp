class Portfolio < ActiveRecord::Base
  attr_accessible :candidate_id, :description, :slider_image, :thumbnail_image, :title
  belongs_to :candidate
  
  mount_uploader :thumbnail_image, PortfolioThumbnailImageUploader
  mount_uploader :slider_image, PortfolioSliderImageUploader
end
