module AML
  class Agreement < ApplicationRecord
    include Archivable
    include Authority::Abilities

    translates :title, :details, touch: true
    globalize_accessors

    scope :ordered, -> { order :id }
  end
end
