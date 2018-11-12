require 'spec_helper'

RSpec.describe AML::Notification, type: :model do
  subject { create :aml_notification }
  it { expect(subject).to be_persisted }
  it { expect(subject.aml_notification_templates).to_not be_empty }
end
