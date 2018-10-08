module AML
  class RejectReasonSerializer
    include FastJsonapi::ObjectSerializer

    set_type :aml_reject_reason

    attributes :title
  end
end
