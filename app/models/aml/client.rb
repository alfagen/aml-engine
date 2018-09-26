# frozen_string_literal: true

# TODO При изменении данных у Клиента создается новая заявка, в нее копируются все документы,
# но статус у них сбрасывается.

module AML
  class Client < ApplicationRecord
    scope :ordered, -> { order 'id desc' }

    has_many :aml_orders, class_name: 'AML::Order', dependent: :destroy
    belongs_to :aml_current_order, class_name: 'AML::Order', dependent: :destroy, foreign_key: :aml_order_id, optional: true
    belongs_to :aml_status, class_name: 'AML::Status', optional: true

    after_create :create_aml_current_order!

    # Нужно для для сериализера
    alias_attribute :aml_current_order_id, :aml_order_id

    # TODO: Не может быть без имени если находится в статусе оформляется или принят/отклонен
    #
    # validates :name
    #
    # TODO При изменении клиента, в случае если он одобрен:
    #
    # 1) Создается новая заявка (create_current_order)
    # 2) workflow клиента сбрабсывается в none
    #

    def create_aml_current_order! attrs = {}
      order = super attrs.merge client_id: id
      update_column :aml_order_id, order.id
    end
  end
end
