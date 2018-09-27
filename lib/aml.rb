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
    Status.find_by(key: default_status_key) || raise("Default state (#{default_status_key}) is not found")
  end

  # Первый документ - паспорт. В нём только номер документа пользователь должен указать.
  # Второй документ - права / загранник. В нём только номер документа.
  # Третий документ - документ подтверждающий адрес. В нём указывает страну, город, индекс и адрес.
  #
  def self.seed_demo!
    DocumentKind.transaction do
      delete_all! true

      g1 = DocumentGroup.create! title: 'Верификация Паспорта'
      d = DocumentKind.create! title: 'Загрузите фотографию вашего пасморта (ID)', aml_document_group: g1
      d = DocumentKind.create! title: 'Загрузите селфи с вашим паспортом', aml_document_group: g1

      g2 = DocumentGroup.create! title: 'Верификация второго документа'
      d = DocumentKind.create! title: 'Загрузите фотографию документа', aml_document_group: g2
      d = DocumentKind.create! title: 'Загрузите селфи с документом', aml_document_group: g2

      Status.create!(title: 'Гостевой', key: default_status_key)

      s1 = Status.create!(title: 'Простой', key: 'personal')
      s1.aml_document_groups << g1

      s2 = Status.create!(title: 'Сложный', key: 'professional')
      s2.aml_document_groups << g1
      s2.aml_document_groups << g2
    end
  end

  def self.delete_all!(permit)
    raise unless permit

    OrderDocument.delete_all
    DocumentKind.delete_all
    DocumentGroupToStatus.delete_all
    DocumentGroup.delete_all
    Order.delete_all
    Client.delete_all
    Status.delete_all
  end

  # После создания новых видов документов, добавляем их во все заявки
  # Пригождается при разработке
  def self.create_documents!
    Order.find_each(&:create_documents!)
  end
end
