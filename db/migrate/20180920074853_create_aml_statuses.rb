class CreateAMLStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_statuses do |t|
      t.string :title, null: false
      t.text :details

      t.timestamps
    end

    add_index :aml_statuses, :title, unique: true
  end
end
