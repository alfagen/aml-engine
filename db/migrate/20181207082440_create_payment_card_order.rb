class CreatePaymentCardOrder < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_payment_card_orders do |t|
      t.string :card_brand
      t.string :card_bin
      t.string :card_suffix
      t.string :image
      t.string :workflow_state, default: :none, null: false
      t.integer :aml_reject_reason_id
      t.string :reject_reason_details

      t.timestamps
    end

    add_reference :aml_payment_card_orders, :aml_client, index: true
  end
end
