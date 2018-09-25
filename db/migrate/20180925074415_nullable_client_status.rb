class NullableClientStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_null :aml_clients, :aml_status_id, true
  end
end
