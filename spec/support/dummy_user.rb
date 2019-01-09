class DummyUser
  attr_accessor  :aml_operator

  include Authority::Abilities
  include Authority::UserAbilities
end
