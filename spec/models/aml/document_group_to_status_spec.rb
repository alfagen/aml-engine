require 'spec_helper'

RSpec.describe AML::DocumentGroupToStatus, type: :model do
  subject { create :aml_document_group_to_status }
  it { expect(subject).to be_persisted }

  it { expect(subject.aml_document_group).to be_a AML::DocumentGroup }
  it { expect(subject.aml_status).to be_a AML::Status }
end
