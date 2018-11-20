# frozen_string_literal: true

# TODO При изменении данных у Клиента создается новая заявка, в нее копируются все документы,
# но статус у них сбрасывается.

module AML
  class Client < ApplicationRecord
    extend Enumerize

    scope :ordered, -> { order 'id desc' }

    belongs_to :current_order, class_name: 'AML::Order', dependent: :destroy, foreign_key: :aml_order_id, optional: true
    belongs_to :aml_accepted_order, class_name: 'AML::Order', dependent: :destroy, optional: true
    belongs_to :aml_status, class_name: 'AML::Status', optional: true

    has_one :aml_client_info, class_name: 'AML::ClientInfo', foreign_key: :aml_client_id

    has_many :orders, class_name: 'AML::Order', dependent: :destroy
    has_many :client_agreements, class_name: 'AML::ClientAgreement', foreign_key: :aml_client_id, dependent: :destroy

    after_create :create_current_order!

    register_currency :eur
    monetize :total_income_amount_cents

    # Нужно для для сериализера
    alias_attribute :current_order_id, :aml_order_id

    enumerize :risk_category, in: %w(A B C)

    # TODO: Не может быть без имени если находится в статусе оформляется или принят/отклонен
    #
    # validates :name
    #
    # TODO При изменении клиента, в случае если он одобрен:
    #
    # 1) Создается новая заявка (create_current_order)
    # 2) workflow клиента сбрабсывается в none
    #

    def create_current_order! attrs = {}
      order = super attrs.merge client_id: id
      update_column :aml_order_id, order.id
    end

    # TODO Сохранять в таблице при before_update/create
    def all_agreements_accepted?
      client_agreements.count == AML::Agreement.alive.count
    end

    def notify(template_id, data = {})
      if email.present?
        AML::NotificationMailer.
          notify( email: email, template_id: template_id, data: data).
          deliver!
      else
        AML::NotificationMailer.logger.error "У клиента #{id} нет email-а"
      end
    end

    def notification_locale
      locale.presence || client_agreements.where.not(locale: nil).pluck(:locale).first
    end

    def reset_status!
      with_lock do
        update aml_status: nil, aml_accepted_order: nil, total_operations_count: 0, total_income_amount: Money.new(0, Money.default_currency)
        create_current_order!
      end
    end

    def name
      [first_name, surname, patronymic].compact.join ' '
    end

    def to_s
      "##{id} #{name}"
    end
  end
end
