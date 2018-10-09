# frozen_string_literal: true
require 'carrierwave'

module AML
  class ApplicationUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
