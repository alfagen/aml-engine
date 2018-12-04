require 'valid_email'

class User < ApplicationRecord
  include Authority::Abilities
  include Authority::UserAbilities

  authenticates_with_sorcery! if defined? Sorcery

  scope :ordered, -> { order 'id desc' }

  has_one :aml_operator, class_name: 'AML::Operator'

  validates :password, length: { minimum: 8 }, on: :update, if: :crypted_password_changed?
  validates :password, confirmation: true, on: :update, if: :crypted_password_changed?
  validates :password_confirmation, presence: true, on: :update, if: :crypted_password_changed?
  validates :email, presence: true, uniqueness: true, email: true

  after_commit :deliver_reset_password_instructions!, on: :create, if: :require_password_instruction?

  def require_password_instruction?
    defined?(Sorcery) && respond_to?(:deliver_reset_password_instructions!)
  end

  def active_for_authentication?
    aml_operator.unblocked?
  end

  # TODO move to sorcery
  #
  def change_password!(new_password)
    clear_reset_password_token
    self.password_confirmation = new_password
    self.password = new_password
    save!
  end

  def time_zone
    return unless time_zone_name.present?

    ActiveSupport::TimeZone[time_zone_name]
  end
end
