class CreateAMLRejectReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_reject_reasons do |t|
      t.text :details, null: false
      t.timestamp :archived_at

      t.timestamps
    end

    add_reference :aml_orders, :aml_reject_reason

    remove_column :aml_orders, :reject_reason
  end
end
