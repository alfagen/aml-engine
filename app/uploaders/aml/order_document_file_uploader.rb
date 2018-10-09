module AML
  class OrderDocumentFileUploader < ApplicationUploader
    after :store, :load!

    delegate :load!, to: :model

    def extension_whitelist
      %w[jpg jpeg gif png]
    end
  end
end
