require 'spec_helper'

RSpec.describe AML::DocumentField, type: :model do
  subject { create :aml_document_field }

  before do
    create :aml_status, :default
  end

  it { expect(subject).to be_persisted }
end
