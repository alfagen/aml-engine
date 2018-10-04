module AML
  class RejectReason < ApplicationRecord
    include Archivable

    validates :title, presence: true, uniqueness: true
  end
end
