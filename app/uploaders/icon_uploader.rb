class IconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fill: [400, 400]

  #アップロードを許可するファイル種類を指定する。
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  # 日付で保存する
  def filename
    time = Time.now
    name = time.strftime('%Y%m%d%H%M%S') + '.png'
    name.downcase
  end
end
