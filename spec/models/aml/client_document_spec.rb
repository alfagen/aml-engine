require 'spec_helper'

RSpec.describe AML::ClientDocument, type: :model do
  let(:document_kind) { create :document_kind } #, :with_definitions }
  subject { create :order_document, document_kind: document_kind }

  it { expect(subject).to be_persisted }
  # it { expect(subject.client_document_fields).to be_two }
end
