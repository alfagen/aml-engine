require_relative 'application_decorator'

module AML
  class OrderExportDecorator < ApplicationDecorator
    delegate_all

    delegate(
      :last_name, :first_name, :maiden_name, :patronymic, :birth_date, :birth_place,
      :gender, :citizenship, :address, :passport_number,
      :second_document_number, :card_suffix, :utility_bill,
      to: :aml_client_info,
      allow_nil: true
    )

    delegate :risk_category, :all_agreements_accepted?, :email, to: :client
  end
end
