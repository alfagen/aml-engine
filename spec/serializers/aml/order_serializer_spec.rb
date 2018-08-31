require 'spec_helper'

describe AML::OrderSerializer, type: :services do
	let!(:order) { create :order }

	subject { described_class.new(order) }

	it 'не падает и отдает Hash' do
		expect(subject.serializable_hash).to be_a Hash
	end
end
