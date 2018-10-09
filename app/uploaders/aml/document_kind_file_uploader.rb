module AML
  class DocumentKindFileUploader < ApplicationUploader
    def extension_whitelist
      %w[pdf]
    end
  end
end
