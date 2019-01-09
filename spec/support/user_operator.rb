module UserOperator
  def user_operator(user, operator)
    user.aml_operator = operator
    allow(controller).to receive(:current_user).and_return user
  end
end
