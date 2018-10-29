require 'spec_helper'

RSpec.describe AML::LimitsChecker do
  let!(:status) { create :aml_status, :default }
  let(:income_amount) { 12.to_money(:eur) }

  subject { described_class.new(aml_client: aml_client) }

  context 'no aml_client' do
    let(:aml_client) { nil }
    it do
      expect {
        subject.check_common_operation! income_amount: income_amount
      }.to raise_error(AML::LimitsChecker::NoClient)
    end
  end

  context 'aml_client' do
    let(:aml_client) { create :aml_client }

    it 'has no status' do
      expect {
        subject.check_common_operation! income_amount: income_amount
      }.to raise_error(AML::LimitsChecker::NoStatus)
    end

    describe 'has status' do
      let!(:status) {
        create :aml_status, :default,
        operations_count_limit: operations_count_limit,
        max_amount_limit: max_amount_limit
      }
      let(:aml_client) {
        create :aml_client, aml_status: status
      }

      describe 'income limits reached' do
        let(:operations_count_limit) { 0 }
        let(:max_amount_limit) { 1000.to_money(:eur) }
        let(:income_amount) { max_amount_limit + 1.to_money(:eur) }
        it do
          expect {
            subject.check_common_operation! income_amount: income_amount
          }.to raise_error(AML::LimitsChecker::MaxAmountReached)
        end
      end

      describe 'operations limits reached' do
        let(:operations_count_limit) { 0 }
        let(:max_amount_limit) { 1000.to_money(:eur) }
        let(:income_amount) { max_amount_limit - 1.to_money(:eur) }
        it do
          expect {
            subject.check_common_operation! income_amount: income_amount
          }.to raise_error(AML::LimitsChecker::MaxOperationsCountReached)
        end
      end

      describe 'no limits' do
        let(:operations_count_limit) { 2 }
        let(:max_amount_limit) { 1000.to_money(:eur) }
        it do
          expect(subject.check_common_operation! income_amount: income_amount).to be_truthy
        end
      end

      describe 'referals' do
        let!(:status) {
          create :aml_status, :default,
          referal_output_enabled: referal_output_enabled
        }
        describe do
          let(:referal_output_enabled) { true }
          let(:income_amount) { 0.to_money(:eur) }
          it do
            expect(subject.check_referal_operation!).to be_truthy
          end
        end
        describe do
          let(:referal_output_enabled) { false }
          it do
            expect {
              subject.check_referal_operation!
            }.to raise_error(AML::LimitsChecker::NoReferalsAllowed)
          end
        end
      end
    end
  end
end
