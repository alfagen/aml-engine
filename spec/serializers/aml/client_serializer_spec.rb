require 'spec_helper'

describe AML::ClientSerializer, type: :services do
  let(:client) { create :client, aml_status: create(:status) }

  subject { described_class.new client, include: described_class.relationships_to_serialize.keys }

  it 'убедимся что у клиента есть заявка которую сериализуем' do
    expect(client.current_order).to be_a AML::Order
  end

  it { expect(subject.as_json).to be_a Hash }
end
