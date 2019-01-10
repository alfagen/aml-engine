class DummyUser
  attr_accessor  :aml_operator

  def initialize(aml_operator: operator)
    @aml_operator = aml_operator
  end

  include Authority::Abilities
  include Authority::UserAbilities
end
