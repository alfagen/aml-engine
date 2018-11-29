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

### Другое

Приложение должно иметь объект `AppVersion` класса `XSemVer::SemVer`
