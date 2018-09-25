require 'spec_helper'

RSpec.describe AML::DocumentKindFieldDefinition, type: :model do
  subject { create :aml_document_kind_field_definition }

  it { expect(subject).to be_persisted }
end
