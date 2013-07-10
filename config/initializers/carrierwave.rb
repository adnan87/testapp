if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider             => 'AWS',
      :aws_access_key_id => 'AKIAI4KXPNFSDQALOGBA',
      :aws_secret_access_key => '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'
    }

    config.fog_directory = 'ijet-prod'
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.storage = :fog
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider             => 'AWS',
      :aws_access_key_id => 'AKIAI4KXPNFSDQALOGBA',
      :aws_secret_access_key => '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'
    }

    config.fog_directory = 'ijet-dev'
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.storage = :fog
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
