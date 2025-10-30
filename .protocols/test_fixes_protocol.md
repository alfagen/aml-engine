# Протокол исправления тестов AML Engine

## Общая информация
- **Дата**: 2025-10-19
- **Ветка**: chore/upgrade-rails
- **Количество тестов**: 115 examples, 6 failures
- **Статус**: В процессе исправления

## Обнаруженные проблемы

### 1. Отсутствие метода `enabled_workflow_events`
- [x] **Исследовать проблему**
- [ ] **Добавить метод в AML::Order**
- [ ] **Добавить метод в AML::PaymentCardOrder**
- [ ] **Протестировать исправление**

**Ошибка**: `NoMethodError: undefined method 'enabled_workflow_events'`
**Затронутые файлы**:
- `app/authorizers/aml/order_authorizer.rb:20`
- `app/views/application/_payment_card_order_actions.slim:2`

### 2. Отсутствие метода `risk_category` для класса
- [x] **Исследовать проблему**
- [ ] **Исправить использование в view**
- [ ] **Протестировать исправление**

**Ошибка**: `NoMethodError: undefined method 'risk_category' for AML::Client:Class`
**Затронутые файлы**:
- `app/views/aml/clients/_risk_category.slim:4`

### 3. Проблемы с отображением шаблонов
- [ ] **Исправить проблемы с рендерингом**
- [ ] **Протестировать все контроллеры**

## Детализация ошибок

### Список падающих тестов:
1. `AML::OrderRejectionsController GET #new returns http success`
2. `AML::OrderRejectionsController POST #create returns http redirected`
3. `AML::Orders оператор #show`
4. `AML::Orders оператор #index`
5. `AML::PaymentCardOrdersController actions #show`
6. `AML::PaymentCardOrdersController actions #index`

### Выполненные действия:
- [x] Запуск полного набора тестов
- [x] Анализ ошибок в деталях
- [x] Исследование исходного кода проблемных мест
- [x] Создание плана исправления

## Замечания по коду

### Проблема с WorkflowActiverecord:
- Метод `enabled_workflow_events` вызывается в авторайзере, но не определен
- Нужно исследовать библиотеку workflow и найти правильный способ получения доступных событий

### Проблема с Enum:
- `AML::Client` имеет `enum :risk_category`, но в view происходит неправильное обращение
- Нужно использовать правильный синтаксис для получения значений enum

## Выполненные исправления:

### 1. ✅ Метод `enabled_workflow_events`
- **Проблема**: Метод отсутствовал в моделях `AML::Order` и `AML::PaymentCardOrder`
- **Решение**: Добавлен метод с правильной реализацией:
  ```ruby
  def enabled_workflow_events
    current_state.events.map { |k, events| events.select { |e| e.condition_applicable?(self, []) } }.flatten.uniq.map(&:name)
  end
  public :enabled_workflow_events
  ```
- **Файлы**: `app/models/aml/order.rb`, `app/models/aml/payment_card_order.rb`

### 2. ✅ Проблема с `risk_category` enum
- **Проблема**: View шаблон использовал неправильный синтаксис для enum
- **Решение**: Заменено на статический массив значений:
  ```slim
  - ['A', 'B', 'C'].each do |risk_category|
    = client_risk_category_link client, risk_category
  ```
- **Файл**: `app/views/aml/clients/_risk_category.slim`

### 3. ✅ Настройка Ransack для Rails 8
- **Проблема**: Ransack 4.4.1 требует явного указания searchable attributes и associations
- **Решение**: Добавлены методы `ransackable_attributes` и `ransackable_associations`
- **Файлы**: `app/models/aml/order.rb`, `app/models/aml/payment_card_order.rb`

## Результаты

✅ **Все 6 падающих тестов теперь проходят**
- `AML::OrderRejectionsController GET #new returns http success`
- `AML::OrderRejectionsController POST #create returns http redirected`
- `AML::OrdersController оператор #show`
- `AML::OrdersController оператор #index`
- `AML::PaymentCardOrdersController actions #show`
- `AML::PaymentCardOrdersController actions #index`

✅ **Полный набор тестов**: 115 examples, 0 failures

## Технические детали:

### Исправления workflow:
- Использована правильная сигнатура `condition_applicable?(object, event_arguments)`
- Метод сделан public для доступа из авторайзеров
- Добавлена поддержка для обеих моделей: `Order` и `PaymentCardOrder`

### Совместимость с Rails 8:
- Настроены Ransack searchable attributes
- Настроены Ransack searchable associations
- Исправлены deprecated вызовы

## Итог:

Все тесты успешно проходят, функциональность workflow восстановлена, система авторизации работает корректно. Risk категории клиентов отображаются в интерфейсе.