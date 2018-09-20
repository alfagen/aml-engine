# frozen_string_literal: true

FactoryBot.define do
  factory(:operator, class: AML::Operator) do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    salt { 'ExqpVWiDcK2vGfeRjqTx' }
    # crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', salt) }
  end
end
