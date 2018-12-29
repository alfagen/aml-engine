module Helpers
  def user_authority(user, controller)
    user.class.include Authority::Abilities
    user.class.include Authority::UserAbilities
    allow(controller).to receive(:current_user).and_return user
  end
end
