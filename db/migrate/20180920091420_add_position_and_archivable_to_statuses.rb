class AddPositionAndArchivableToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_statuses, :position, :integer
    add_column :aml_statuses, :archived_at, :timestamp
  end
end
