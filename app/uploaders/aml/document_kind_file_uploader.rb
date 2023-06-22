module AML
  class DocumentKindFileUploader < ApplicationUploader
    def extension_allowlist
      %w[pdf]
    end
  end
end
