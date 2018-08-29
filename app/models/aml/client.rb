# frozen_string_literal: true

module AML
  class Client < ApplicationRecord
    include Authority::Abilities

    self.table_name = 'aml_clients'

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy

    validates :name, presence: true
    validates :inn, presence: true, uniqueness: true
  end
end
