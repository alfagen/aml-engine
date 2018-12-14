module AML::CardValidation
  extend ActiveSupport::Concern

  included do 
    validates :card_brand, presence: true
    validates :card_bin, presence: true, length: 4..8
    validates :card_suffix, presence: true, length: 2..4
  end
end
