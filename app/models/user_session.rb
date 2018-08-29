class UserSession
  include Virtus.model
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  include ActiveModel::Validations

  attribute :login, String
  attribute :password, String
  attribute :remember_me, Axiom::Types::Boolean

  validates :login, presence: true
  validates :password, presence: true

  def persisted?
    false
  end
end
