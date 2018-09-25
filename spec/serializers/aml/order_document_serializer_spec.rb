require 'spec_helper'

describe AML::OrderDocumentSerializer, type: :services do
  let(:aml_status) { create :aml_status, :default }
  let(:aml_order) { create :aml_order, aml_status_id: aml_status.id }
  let(:aml_document_kind) { create :aml_document_kind }

  subject { create :aml_order_document, order_id: aml_order.id }

  let(:serializer) { described_class.new subject, include: described_class.relationships_to_serialize.keys }
  it { expect(serializer.as_json).to be_a Hash }
end
