module AML
  class CardImageFileUploader < ApplicationUploader
    def extension_whitelist
      %w[jpg jpeg gif png]
    end
  end
end
