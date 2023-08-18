class DigestService < ApplicationService
  class << self
    def sha256_hexdigest(payload)
      Digest::SHA256.hexdigest(payload)
    end
  end
end
