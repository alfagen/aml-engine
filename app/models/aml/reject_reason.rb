module AML
  class RejectReason < ApplicationRecord
    include Archivable
    scope :ordered, -> { order 'id desc' }

    validates :title, presence: true, uniqueness: true
  end
end
