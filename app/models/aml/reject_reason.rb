module AML
  class RejectReason < ApplicationRecord
    include Archivable

    scope :ordered, -> { order :id }

    validates :title, presence: true, uniqueness: true
  end
end
