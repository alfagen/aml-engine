class AddReferalOutputEnabledToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_statuses, :referal_output_enabled, :boolean, null: false, default: false
  end
end
