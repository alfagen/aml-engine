class CreatePaymentCard < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_payment_cards do |t|
      t.string :brand
      t.string :bin, limit: 6
      t.string :suffix, limit: 4

      t.timestamps
    end

    add_reference :aml_payment_cards, :aml_client, index: true
    add_reference :aml_payment_cards, :aml_order, index: true
    add_index :aml_payment_cards, [:aml_client_id, :bin, :suffix, :brand], unique: true, name: 'client_bin_suffix_brand'
  end
end
