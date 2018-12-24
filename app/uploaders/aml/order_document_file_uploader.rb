module AML
  class OrderDocumentFileUploader < ApplicationUploader
    after :store, :load!

    # TODO Избавиться в пользу метода в модели Order
    delegate :load!, to: :model

    def extension_whitelist
      %w[jpg jpeg gif png]
    end
  end
end
