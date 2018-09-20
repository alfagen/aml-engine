class AddStatusToClient < ActiveRecord::Migration[5.2]
  def change
    add_reference :aml_clients, :aml_status, foreign_key: true
  end
end
