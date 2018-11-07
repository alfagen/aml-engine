require 'spec_helper'

RSpec.describe AML::CheckList, type: :model do
  let!(:aml_status) { create :aml_status, :default }

  context 'При добавлении чек-листа требование его принять добавляется в заявки со статусом pending/processing' do
    let!(:order) { create :aml_order, :pending }
    it { expect(order.order_checks).to be_empty }
    it { expect(order.aml_check_lists).to be_empty }

    it do
      check_list = create :aml_check_list

      expect(order.aml_check_lists).to include(check_list)
      expect(order.order_checks.count).to eq 1
      check_list.destroy!

      expect(order.aml_check_lists).to be_empty
      expect(order.order_checks).to be_empty
    end
  end
end
