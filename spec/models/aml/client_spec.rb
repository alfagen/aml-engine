require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  subject { create :aml_client }

  before do
    # нужен для заявки
    create :aml_status, :default
  end

  it { expect(subject).to be_persisted }
  it { expect(subject.aml_status).to be_nil }
  it { expect(subject.aml_current_order).to be_persisted }
end
