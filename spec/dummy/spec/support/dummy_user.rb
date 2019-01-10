class DummyUser
  include Authority::Abilities
  include Authority::UserAbilities

  attr_reader :aml_operator

  def initialize(aml_operator: operator)
    @aml_operator = aml_operator
  end
end
