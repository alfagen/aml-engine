class RenameCardFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :aml_payment_cards, :brand, :card_brand
    rename_column :aml_payment_cards, :bin, :card_bin
    rename_column :aml_payment_cards, :suffix, :card_suffix
  end
end
