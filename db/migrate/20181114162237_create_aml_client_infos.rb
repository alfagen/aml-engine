class CreateAMLClientInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :aml_client_infos do |t|
      t.references :aml_client, foreign_key: true, null: false
      t.string :first_name
      t.string :maiden_name
      t.string :last_name
      t.string :patronymic
      t.date :birth_date
      t.string :birth_place
      t.string :gender
      t.text :address
      t.string :citizenship
      t.string :passport_number
      t.string :second_document_number
      t.string :card_suffix, length: 4
      t.string :utility_bill

      t.timestamps
    end
  end
end
