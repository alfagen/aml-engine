# frozen_string_literal: true

module AML
  class Client < ApplicationRecord
    include Authority::Abilities

    self.table_name = 'aml_clients'

    scope :ordered, -> { order 'id desc' }

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_one :current_order, class_name: 'AML::Order', dependent: :nullify

    after_create :create_current_order!

    # TODO: Не может быть без имени если находится в статусе оформляется или принят/отклонен
    #
    # validates :name
    #
    # TODO При изменении клиента, в случае если он одобрен:
    #
    # 1) Создается новая заявка (create_current_order)
    # 2) workflow клиента сбрабсывается в none
    #

    def current_order!
      with_lock do
        current_order || create_current_order!
      end
    end

    private

    def create_current_order!
      super client_id: id
    end
  end
end
