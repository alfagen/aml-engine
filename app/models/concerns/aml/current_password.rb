module AML
  module CurrentPassword
    extend ActiveSupport::Concern

    included do
      attr_accessor :current_password

      before_validation :validate_current_password, if: :current_password_required?
      validates :current_password, presence: true, if: :current_password_required?
    end

    private

    def validate_current_password
      return if valid_password? current_password
      errors.add :current_password, 'Текущий пароль не верен.'
    end

    def current_password_required?
      crypted_password? && crypted_password_was.present? && persisted? && !email?
    end
  end
end
