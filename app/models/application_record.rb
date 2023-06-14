class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :created_within, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  def self.api_key_generator
    return "API-RM#{SecureRandom.hex(32)}"
  end

  def self.generate_qr(data)
    qrcode = RQRCode::QRCode.new(data)

    png = qrcode.as_png(
    bit_depth: 1,
    border_modules: 4,
    color_mode: ChunkyPNG::COLOR_GRAYSCALE,
    color: 'black',
    file: nil,
    fill: 'white',
    module_px_size: 6,
    resize_exactly_to: false,
    resize_gte_to: false,
    size: 120
    )

    Base64.encode64(png.to_s)
  end
end
