module AML
  class DocumentGroup < ApplicationRecord
    include Authority::Abilities
    include Archivable

    has_many :document_kinds, class_name: 'AML::DocumentKinds', dependent: :destroy

    scope :ordered, -> { order :position }

    validates :title, presence: true, uniqueness: true
  end
end
