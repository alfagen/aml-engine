require 'archivable'

require "aml/engine"

module AML
  def self.table_name_prefix
    'aml_'
  end

  # Название статуса по-умолчанию для первой заявки клиента
  # Используется только потому, что фронт устроен так, что требует
  # наличия какой-то заявки.
  def self.default_status_key
    'guest'
  end

  def self.default_status
    AML::Status.find_by(key: default_status_key) || raise("Default state (#{default_status_key}) is not found")
  end

  # Первый документ - паспорт. В нём только номер документа пользователь должен указать.
  # Второй документ - права / загранник. В нём только номер документа.
  # Третий документ - документ подтверждающий адрес. В нём указывает страну, город, индекс и адрес.
  #
  def self.seed_demo!
    AML::DocumentKind.transaction do
      delete_all! true

      g1 = AML::DocumentGroup.create! title: 'Верификация Паспорта'
      d = AML::DocumentKind.create! title: 'Загрузите фотографию вашего пасморта (ID)', aml_document_group: g1
      d = AML::DocumentKind.create! title: 'Загрузите селфи с вашим паспортом',aml_document_group: g1

      g2 = AML::DocumentGroup.create! title: 'Верификация второго документа'
      d = AML::DocumentKind.create! title: 'Загрузите фотографию документа', aml_document_group: g2
      d = AML::DocumentKind.create! title: 'Загрузите селфи с документом', aml_document_group: g2

      AML::Status.create!(title: 'Гостевой', key: AML.default_status_key)

      s1 = AML::Status.create!(title: 'Простой', key: 'personal')
      s1.aml_document_groups << g1

      s2 = AML::Status.create!(title: 'Сложный', key: 'professional')
      s2.aml_document_groups << g1
      s2.aml_document_groups << g2
    end
  end

  def self.delete_all!(permit)
    raise unless permit

    AML::OrderDocument.delete_all
    AML::DocumentKind.delete_all
    AML::DocumentGroupToStatus.delete_all
    AML::DocumentGroup.delete_all
    AML::Order.delete_all
    AML::Client.delete_all
    AML::Status.delete_all
  end

  # После создания новых видов документов, добавляем их во все заявки
  # Пригождается при разработке
  def self.create_documents!
    AML::Order.find_each(&:create_documents!)
  end
end
