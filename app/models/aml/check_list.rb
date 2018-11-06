module AML
  class CheckList < ApplicationRecord
    include Archivable

    scope :ordered, -> { order :position }

    validates :title, presence: true, uniqueness: true
  end
end
