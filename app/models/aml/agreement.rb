module AML
  class Agreement < ApplicationRecord
    include Archivable

    translates :title, :details, touch: true
    globalize_accessors

    scope :ordered, -> { order :id }
  end
end
