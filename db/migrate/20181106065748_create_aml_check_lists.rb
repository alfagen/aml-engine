class CreateAMLCheckLists < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_check_lists do |t|
      t.string :title, null: false
      t.string :url
      t.integer :position, null: false, default: 0
      t.timestamp :archived_at

      t.timestamps
    end

    add_index :aml_check_lists, :title, unique: true
  end
end
