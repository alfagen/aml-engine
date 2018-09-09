module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities
    include Archivable

    belongs_to :client, class_name: 'AML::Client', foreign_key: 'client_id', inverse_of: :orders, dependent: :destroy
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: 'operator_id', optional: true, inverse_of: :orders

    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy

    scope :ordered, -> { order 'id desc' }

    enumerize :workflow_state, in: %w[none pending processing accepted rejected], scope: true

    # TODO: в noe статус может быть без этих полей
    # validates :first_name, presence: true
    # validates :surname, presence: true
    # validates :patronymic, presence: true
    #
    # TODO Проверять что заявку можно менять
    ## TODO validate date
    # validates :birth_date, presence: true

    workflow do
      # Находится на стадии загрузки пользователем
      #
      state :none do
        event :load, transitions_to: :pending
      end

      # Пользователь загрузил, ждет когда оператор начнет обрабатывать
      state :pending do
        event :process, transitions_to: :processing
      end

      # Оператор начал обрабатывать
      state :processing do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
        event :stop, transitions_to: :pending
      end

      state :accepted do
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    after_create :create_documents!

    def is_locked?
      accepted? || processing? || accepted? || rejected?
    end

    def complete?
      order_documents.select(:complete?).count == order_documents.count
    end

    def get_order_document_by_kind(document_kind)
      with_lock do
        order_documents
          .create_with(order: self)
          .find_or_create_by!(document_kind: document_kind)
      end
    end

    def missing_document_kinds
      DocumentKind.where.not(id: order_documents.pluck(:document_kind_id))
    end

    private

    def create_documents!
      DocumentKind.alive.each do  |document_kind|
        order_documents.create! order: self, document_kind: document_kind
      end
    end
  end
end
