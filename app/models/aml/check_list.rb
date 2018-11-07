module AML
  class CheckList < ApplicationRecord
    include Archivable

    scope :ordered, -> { order :position }

    validates :title, presence: true, uniqueness: true

    def to_s
      title
    end
  end
end
