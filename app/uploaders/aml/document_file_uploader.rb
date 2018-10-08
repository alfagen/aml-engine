require 'carrierwave'

module AML
  class DocumentFileUploader < FileUploader
    after :store, :load!

    delegate :load!, to: :model
  end
end
