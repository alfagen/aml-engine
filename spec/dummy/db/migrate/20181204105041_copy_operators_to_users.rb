class CopyOperatorsToUsers < ActiveRecord::Migration[5.2]
  def up
    AML::Operator.find_each do |operator|
      user = User.find_or_create_by!(email: operator.email, crypted_password: operator.crypted_password,
                                     salt: operator.salt, time_zone_name: operator.time_zone_name,
                                     locale: operator.locale, name: operator.name)
      operator.update user_id: user.id
    end
  end

  def down
    AML::Operator.update_all user_id: nil
  end
end
