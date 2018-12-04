class RemoveFromOperator < ActiveRecord::Migration[5.2]
  def change
    remove_column :aml_operators, :email, :string
    remove_column :aml_operators, :crypted_password, :string
    remove_column :aml_operators, :salt, :string
    remove_column :aml_operators, :reset_password_token, :string
    remove_column :aml_operators, :reset_password_token_expires_at, :datetime
    remove_column :aml_operators, :reset_password_email_sent_at, :datetime
    remove_column :aml_operators, :access_count_to_reset_password_page, :integer
    remove_column :aml_operators, :name, :string
    remove_column :aml_operators, :locale, :string
    remove_column :aml_operators, :time_zone_name, :string
  end
end
