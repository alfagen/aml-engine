# AML engine

[![Build Status](https://travis-ci.org/alfagen/aml-engine.svg?branch=master)](https://travis-ci.org/alfagen/aml-engine)


## Статусы документа

![Статусы документа](https://github.com/alfagen/aml-engine/blob/master/doc/aml_order_documents_workflow.png?raw=true)

## Статусы заявки

![Статусы заявки](https://github.com/alfagen/aml-engine/blob/master/doc/aml_orders_workflow.png?raw=true)

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
