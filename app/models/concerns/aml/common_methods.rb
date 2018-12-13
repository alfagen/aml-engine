module AML
  module CommonMethods
    extend ActiveSupport::Concern

    def start(operator:)
      update operator: operator
    end

    def cancel
      update operator: nil
      touch :operated_at
    end

    def client_name
      ["##{client.id}", client.first_name, client.surname, client.patronymic].compact.join ' '
    end

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
      touch :operated_at
    end

    def is_owner?(operator)
      self.operator == operator
    end

    def accepted_at
      return operated_at if accepted?
    end
  end
end
