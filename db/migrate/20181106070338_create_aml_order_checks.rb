class CreateAMLOrderChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_order_checks do |t|
      t.references :aml_order, foreign_key: true, null: false
      t.references :aml_check_list, foreign_key: true, null: false
      t.string :workflow_state, null: false, default: 'none'

      t.timestamps
    end

    add_index :aml_order_checks, [:aml_order_id, :aml_check_list_id], unique: true
  end
end
