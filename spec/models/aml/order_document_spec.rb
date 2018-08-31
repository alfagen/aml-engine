require 'spec_helper'

RSpec.describe AML::OrderDocument, type: :model do
  let(:order) { create :order }

  subject { create :order_document, order: order, document_kind: document_kind }

  context 'вид документа без полей' do
    let(:document_kind) { create :document_kind }
    it { expect(subject.client_document_fields).to be_empty }
  end

  context 'если в виде документа есть дефиниции, то под них создаются поля' do
    let(:document_kind) { create :document_kind, :with_definitions }
    it { expect(subject.client_document_fields).to be_many }
  end
end
