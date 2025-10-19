# AML engine

[![Build Status](https://travis-ci.org/alfagen/aml-engine.svg?branch=master)](https://travis-ci.org/alfagen/aml-engine)
[![Tests](https://github.com/alfagen/aml-engine/workflows/Tests/badge.svg)](https://github.com/alfagen/aml-engine/actions/workflows/tests.yml)

AML Engine - это монтируемый Ruby on Rails движок для соответствия требованиям противодействия отмыванию денег (AML) на криптовалютной биржевой платформе Kassa.

## Статусы документа

![Статусы документа](https://github.com/alfagen/aml-engine/blob/master/doc/aml_order_documents_workflow.png?raw=true)

## Статусы заявки

![Статусы заявки](https://github.com/alfagen/aml-engine/blob/master/doc/aml_orders_workflow.png?raw=true)

## Установка и настройка

### Требования
- Ruby 2.7.8 (управляется через rbenv)
- MySQL база данных
- Rails 6.x
- Доступ к основному проекту Kassa Admin для тестирования

### Настройка базы данных для тестов

**Перед запуском тестов необходимо настроить тестовую базу данных:**

1. **Сброс и создание тестовой базы данных:**
   ```bash
   BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rake db:drop db:create
   ```

2. **Запуск миграций для разработки и тестовых сред:**
   ```bash
   # Среда разработки
   BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rake db:migrate

   # Тестовая среда
   BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile RAILS_ENV=test bundle exec rake db:migrate
   ```

3. **Установка миграций AML в основном приложении:**
   ```bash
   cd /home/danil/code/kassa-admin
   bundle exec rails aml:install:migrations
   ```

### Запуск тестов

**Вариант 1: Из основного проекта Kassa Admin (рекомендуется для интеграционного тестирования)**
```bash
cd /home/danil/code/kassa-admin
bundle exec rspec vendor/aml/spec

# Запуск конкретных тестовых файлов
bundle exec rspec vendor/aml/spec/models/aml/order_spec.rb

# Запуск с разными форматами вывода
bundle exec rspec vendor/aml/spec --format documentation
bundle exec rspec vendor/aml/spec --format progress
```

**Вариант 2: Из директории AML Engine (для изолированного тестирования)**
```bash
# Установить правильный Gemfile и запустить тесты
BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rspec spec --format documentation

# Запуск конкретных тестовых файлов
BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rspec spec/models/aml/order_spec.rb --format documentation

# Запуск с форматом progress
BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rspec spec --format progress
```

### Доступные Rake задачи
```bash
# Генерация диаграмм workflow для моделей
bundle exec rake doc:workflow MODEL=Order

# Запуск набора тестов по умолчанию
bundle exec rake spec

# Просмотр всех доступных задач
bundle exec rake -T
```

### Устранение распространенных проблем

**Проблемы с миграциями:**
- **Проблема**: `ActiveRecord::PendingMigrationError` или "Migrations are pending"
- **Решение**: Выполнить `BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rake db:migrate RAILS_ENV=test`

**Проблемы с настройкой базы данных:**
- **Проблема**: Ошибки ограничений внешнего ключа во время миграции
- **Решение**: Полностью сбросить базу данных: `BUNDLE_GEMFILE=/home/danil/code/kassa-admin/Gemfile bundle exec rake db:drop db:create db:migrate`

**Проблемы с enum:**
- **Проблема**: Ошибки `Undeclared attribute type for enum`
- **Решение**: Убедиться, что все миграции выполнены, включая миграции полей enum, такие как `Add risk category to clients`

## Приложение должно поддерживать следующий интерфейс:

### Routes

| Пути                                                                                     | Действия                               |
|------------------------------------------------------------------------------------------|----------------------------------------|
| new_user_session_path (get), user_sessions_path (post)                                   | логин                                  |
| user_session_path (delete)                                                               | логаут                                 |
| new_password_reset_path (get), edit_password_reset_path (get), password_reset_path (put) | первое изменение пароля при регистрации|
| edit_password_path (get), password_path (put)                                            | изменение пароля                       |
| edit_user_path (get), user_path (put)                                                    | редактирование профиля пользователя    |
| locale_path (put)                                                                        | изменение локали пользователя          |


### Пример подключения в config/initializers/aml.rb

```ruby
AML.configure do |config|
  config.allowed_emails = Secrets.aml_allowed_emails
  config.mail_from = Settings.mailer.default_from
  config.logger = ActiveSupport::Logger.new Rails.root.join './log/aml.log'
end

Rails.application.config.after_initialize do
  [
    AML::Order, AML::Client, AML::Operator, AML::OrderDocument,
    AML::DocumentKindFieldDefinition, AML::DocumentKind, AML::DocumentGroup, AML::DocumentField
  ].each { |model| model.include Authority::Abilities }

  class AML::Operator
    has_one :user, class_name: 'User', foreign_key: :aml_operator_id

    def email
      return "no user for AML::Operator #{id}" unless user.present?

      user.email
    end

    def name
      return "no user AML::Operator #{id}" unless user.present?

      user.name
    end
  end
end
```

### ApplicationController

* current_user
* current_time_zone

### Другое

Приложение должно иметь объект `AppVersion` класса `XSemVer::SemVer`
