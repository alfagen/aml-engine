require 'spec_helper'

describe AML::ClientSerializer, type: :services do
  let(:aml_client) { create :aml_client, aml_status: create(:aml_status) }

  subject { described_class.new aml_client, include: described_class.relationships_to_serialize.keys }

  it 'убедимся что у клиента есть заявка которую сериализуем' do
    expect(aml_client.current_order).to be_a AML::Order
  end

  it { expect(subject.as_json).to be_a Hash }
end
