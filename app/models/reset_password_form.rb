class ResetPasswordForm
  include Virtus.model
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  include ActiveModel::Validations

  attribute :email, String
  validates :email, presence: true
end
