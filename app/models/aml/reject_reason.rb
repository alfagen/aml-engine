module AML
  class RejectReason < ApplicationRecord
    include Archivable
    scope :ordered, -> { order :id }

    has_many :orders, foreign_key: :aml_reject_reason_id

    validates :title, presence: true, uniqueness: true
  end
end
