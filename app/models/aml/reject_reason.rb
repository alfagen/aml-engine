module AML
  class RejectReason < ApplicationRecord
    include Archivable

    validates :details, presence: true, uniqueness: true
  end
end
