class AddTimeZone < ActiveRecord::Migration[5.2]
  def change
    add_column :aml_operators, :time_zone, :string
  end
end
