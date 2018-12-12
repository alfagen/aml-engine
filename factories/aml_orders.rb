FactoryBot.define do
  factory(:aml_order, class: AML::Order) do
    first_name { 'First name' }
    surname { 'Surname' }
    patronymic { 'patronymic' }
    card_brand { 'card_brand' }
    card_bin { '111111' }
    card_suffix { '1111' }
    birth_date { Time.zone.today - 30.years }
    association :client, factory: [:aml_client, :with_risk]
    association :operator, factory: :aml_operator
    aml_status

    trait :none do
      workflow_state { :none }
      association :order_documents, factory: [:aml_order_document, :none]
    end

    trait :pending do
      after :create do |order|
        create_list :aml_order_document, 2, :loaded, order: order
        order.done!
      end
    end

    trait :processing do
      after :create do |order|
        create_list :aml_order_document, 2, :loaded, order: order
        order.done!
        order.start!(operator: order.operator)
      end
    end

    trait :accepted do
      after :create do |order|
        create_list :aml_order_document, 2, :loaded, order: order
        order.done!
        order.start!(operator: order.operator)
        order.accept!
      end
    end

    trait :rejected do
      after :create do |order|
        create_list :aml_order_document, 2, :loaded, order: order
        order.done!
        order.start!(operator: order.operator)
        order.reject!(reject_reason: create(:aml_reject_reason, :order_reason), details: 'reject reason details')
      end
    end
  end
end
